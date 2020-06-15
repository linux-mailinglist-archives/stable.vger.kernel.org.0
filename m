Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D08D1F9AA5
	for <lists+stable@lfdr.de>; Mon, 15 Jun 2020 16:46:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730405AbgFOOqG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jun 2020 10:46:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730213AbgFOOqF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Jun 2020 10:46:05 -0400
Received: from mail-lf1-x142.google.com (mail-lf1-x142.google.com [IPv6:2a00:1450:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A11EAC061A0E;
        Mon, 15 Jun 2020 07:46:05 -0700 (PDT)
Received: by mail-lf1-x142.google.com with SMTP id g2so2094805lfb.0;
        Mon, 15 Jun 2020 07:46:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2evxLdSYjOMMyGDiQXV+GMESd1HuNoecTxX/6bQf6M0=;
        b=YGzbZ1OOJzf8OQ2kn9AXktEQsgbGeFkyMh2kQSscYGc03DSBx3enRlXrgyetS2aszi
         8ZRYphx5pTl2r1RgsFGgwW25lwjiQmEXDR8b5L9oHMLTqFO72ANmzCayhQwS0ISl0mAk
         ypsNiINo24tH3z1mTT2yC9z0UjETwXmM4l0XLj5FVfZ6xiMdSzF+YNoGQAD9Y21YwV5K
         ALZ5nqKD7/m9PeoxXjeuTdBAfzm/Y+0ycRs+Jx/dWiACr7p3RfmUIABauhVDKMS921Nj
         AqbYeutajvAH94DZOXI7a2idYBak6SLaRG57qd7ytHQGiH372noLRH9ry5KBdNN3z+R5
         +xSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2evxLdSYjOMMyGDiQXV+GMESd1HuNoecTxX/6bQf6M0=;
        b=NoeJMCXFJUg23lsu/U7rdMMgRzrDSj4B+NSJoD60Y1vhh7T6ipP/iLiu+bR1rpg7+C
         2kzSRO842yuK77OCi/B6J/FxHAVzyYo1OD4ibNonEWP2vVnBdb9dR7Ls2iEmHr8xR7cd
         XMsrf2mQ5piwTKiiSXE+Elx+MwZXLo2wuANgRGkeUVsWmZGmUAXDCt3L09ouUvOkQeaC
         qq5AowkDEv/mAo5EmIffvT2H+so1NpwvDgZGiIhgTGNgdxyzBnKhERGEnqcn6KiKMQrz
         TMaqo71N5pLW75SC8kLTiy67NDRh5gF5qxiE0giP84lnds6vEYRLWFwN+y8PITq5S01M
         t9lg==
X-Gm-Message-State: AOAM531x3x04aSxYqoZIKDzE7WZniKnoYKPm8E/owygn54jj2YidLVdQ
        vRxa9QgyEWf+9J1gtp5kB64cscgqTSvi2RqCpl81fQU/
X-Google-Smtp-Source: ABdhPJzGq32dl07RYow13CE+qUf72RKnAmPMdwY07CPQKZwGRAPjwP4RCmw4PbTEAhFg3bu6iX81NN4fPXlX5lqSWVw=
X-Received: by 2002:ac2:5962:: with SMTP id h2mr1573341lfp.66.1592232364108;
 Mon, 15 Jun 2020 07:46:04 -0700 (PDT)
MIME-Version: 1.0
References: <20200615131934.12440-1-aford173@gmail.com>
In-Reply-To: <20200615131934.12440-1-aford173@gmail.com>
From:   Fabio Estevam <festevam@gmail.com>
Date:   Mon, 15 Jun 2020 11:45:52 -0300
Message-ID: <CAOMZO5Bw5qSDirAKBTRcu4_nDafDcfDGpuNRDyuLZs9Zc=HsQA@mail.gmail.com>
Subject: Re: [PATCH] drm/panel-simple: fix connector type for LogicPD Type28 Display
To:     Adam Ford <aford173@gmail.com>
Cc:     DRI mailing list <dri-devel@lists.freedesktop.org>,
        David Airlie <airlied@linux.ie>,
        Adam Ford-BE <aford@beaconembedded.com>,
        stable <stable@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Sam Ravnborg <sam@ravnborg.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 15, 2020 at 10:19 AM Adam Ford <aford173@gmail.com> wrote:
>
> The LogicPD Type28 display used by several Logic PD products has not
> worked since v5.5.

Maybe you could tell which commit exactly and then put a Fixes tag?
