Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A1D24E8A9
	for <lists+stable@lfdr.de>; Fri, 21 Jun 2019 15:13:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726779AbfFUNNE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Jun 2019 09:13:04 -0400
Received: from mail-oi1-f174.google.com ([209.85.167.174]:40692 "EHLO
        mail-oi1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726250AbfFUNNE (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Jun 2019 09:13:04 -0400
Received: by mail-oi1-f174.google.com with SMTP id w196so4593636oie.7;
        Fri, 21 Jun 2019 06:13:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xbpBRnqznlE1HEOg4PMUeAxG8c4K8U2mrJuFqdy7uIk=;
        b=sYcQzVQZGmYiospFy6xHHYqirJZOuwtGTHteF3hrd6HJFa37sB8QFbtoRb/FpAVZLM
         VHllJURSAsPdp9nJetdSnhmV4r+J4y6CQUG4Cc7iOrTMqhft58DyFYbVv5mP9dgGdYHj
         rrB6tAdjjoekHtnbJ5Z6WzAoz7MHo3txECsawROdITRy7LFMTh9zwM3nKakZVyDra2Oh
         NjzzbJc3ttcfEd8mXcyDyWjXc2iYHC7RgIhLYvUdXlPUCaE5OTM4gpQdIUs+r5ti+Rv/
         jyd/ChvkcoE3m8gyCZh4ye83hSi4y1m1xU+inWTdzNMFHb78HfKsJFBGPPeIurZJGiBy
         FD9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xbpBRnqznlE1HEOg4PMUeAxG8c4K8U2mrJuFqdy7uIk=;
        b=rHBf+QqAbBETlaa7AoA5XVS0yGdpq/2zSepeoDgzLWBrZBX5RQzBmSwTLuYWABFxAJ
         694i3iXvrI87QDP2Fb/eZFVmBjQGRDY1+LNiGCiVBNUSyHoK6ppwcv0EfieHO4pypVh9
         7uu4mCurdlDdGXoTOKKva7cMRdglzOPe2R9zlpjTcD7OLmjKQFSj/IVNgudtDqMtf+NU
         kA4OvrOTu/t8G7mbJzac+U+r2/b7Y+lWt/8ae3DJ8yRclLuN5tDR4zlGkBss8VLaKczY
         ydHBuLM9HYd7e1KFTLDSMBPOYE4Yllahy4phCvMy7VVpoPvv+sZPilW9f9ouV8yEOt6Y
         N0RQ==
X-Gm-Message-State: APjAAAWu66JHTYSUuNRNYMt0QpoOd3ti8pqr/4F8hgnyUvJp+akT6KY/
        abo5ocaaH72lLvpKpFcIlI4gc/phD7TuovZoNeY=
X-Google-Smtp-Source: APXvYqwjEBY5aO3xWboVF20/ol00HqPWoPQpKV6X29y5l3AWbmItb1r0IrYBUeVyN/FhaOXV+CYlu15nJASM4OMp+f4=
X-Received: by 2002:aca:edc6:: with SMTP id l189mr2559572oih.86.1561122782951;
 Fri, 21 Jun 2019 06:13:02 -0700 (PDT)
MIME-Version: 1.0
References: <20190621082306.34415-1-yibin.gong@nxp.com>
In-Reply-To: <20190621082306.34415-1-yibin.gong@nxp.com>
From:   Sven Van Asbroeck <thesven73@gmail.com>
Date:   Fri, 21 Jun 2019 09:12:51 -0400
Message-ID: <CAGngYiWx-QML6XDG3LWRR-qHTmKeJV68zD-a8qSFf4SmH=nVzQ@mail.gmail.com>
Subject: Re: [PATCH v2] dmaengine: imx-sdma: remove BD_INTR for channel0
To:     Robin Gong <yibin.gong@nxp.com>
Cc:     Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>, Vinod <vkoul@kernel.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Michael Olbrich <m.olbrich@pengutronix.de>,
        NXP Linux Team <linux-imx@nxp.com>,
        Stable <stable@vger.kernel.org>,
        "moderated list:ARM/FREESCALE IMX / MXC ARM ARCHITECTURE" 
        <linux-arm-kernel@lists.infradead.org>, dmaengine@vger.kernel.org,
        Sascha Hauer <kernel@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Looking great.

Thank you for taking the time for this, Robin !
