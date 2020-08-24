Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFF8524F5DF
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 10:54:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730342AbgHXIyg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 04:54:36 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:42373 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730330AbgHXIyb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Aug 2020 04:54:31 -0400
Received: by mail-lf1-f68.google.com with SMTP id c8so4043199lfh.9;
        Mon, 24 Aug 2020 01:54:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=LaVue5RwtmgkAnddefWKALJdn/bQBbjIItjnFY5oPlY=;
        b=JZbmIsMYytG0w1wKqsBUs9VO3are4U4EPGrAvtgmniMbD4Gka2evEaOKFnBnRew0va
         0y7kb1mfKrbPKguke9/CoGSPBhbAXm/DF2kii7ml6Xbte6bnbrybG4xJEa4hldcvt+UU
         i5Tlrkyv3892yPn0TtZBr03TVi0gJId92oQxlte1WjXuevClaU20Wx1pwcqh1X7cO5w4
         ZIgTtgqxLyqn1XNro1OcWjozcOEAjpjIJwTkDHE47IGxVqVptkWB1HHx8yxWRnXalsqD
         cbc9qkCZ0EBja4HO8g5EoMx9Ht2yEKDd5uzuY8B4DBumVxxrssDf94nYIq3fBj0x8j/P
         FnPw==
X-Gm-Message-State: AOAM530YcFnS1FpY0VfkdRbOD1TfJfXlFfLADWrxPvQnRbTMpKtMQqSh
        9ZOp/iDfwSQM7d3u1O4aVPM=
X-Google-Smtp-Source: ABdhPJyhNc80MZicMYsowMdF6QWL9vuM/rf/AYpQF4xqCVSLiEfxkiJjphMZ943rBguzXc3EKaHLkg==
X-Received: by 2002:a19:480b:: with SMTP id v11mr2171612lfa.130.1598259266779;
        Mon, 24 Aug 2020 01:54:26 -0700 (PDT)
Received: from xi.terra (c-beaee455.07-184-6d6c6d4.bbcust.telenor.se. [85.228.174.190])
        by smtp.gmail.com with ESMTPSA id z18sm2046998lji.107.2020.08.24.01.54.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Aug 2020 01:54:26 -0700 (PDT)
Received: from johan by xi.terra with local (Exim 4.93.0.4)
        (envelope-from <johan@kernel.org>)
        id 1kA8FE-0006oj-Ij; Mon, 24 Aug 2020 10:54:25 +0200
Date:   Mon, 24 Aug 2020 10:54:24 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Johan Hovold <johan@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.8 137/232] USB: serial: ftdi_sio: fix break and sysrq
 handling
Message-ID: <20200824085424.GB21288@localhost>
References: <20200820091612.692383444@linuxfoundation.org>
 <20200820091619.460392380@linuxfoundation.org>
 <CAMgPeKX54WqE0Wc56u6W3M2JwttV=E7sBKmM5eRa5_Mu7m+okg@mail.gmail.com>
 <20200820095652.GA1266907@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200820095652.GA1266907@kroah.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 20, 2020 at 11:56:52AM +0200, Greg Kroah-Hartman wrote:
> On Thu, Aug 20, 2020 at 11:51:56AM +0200, Johan Hovold wrote:
> > This was never intended for stable as it is not a critical fix and has
> > never worked properly in the first place. Please drop this one and the
> > preparatory clean ups from all stable trees.
> 
> Ok, but the "fix this thing" and the "Fixes:" tag really did imply this
> was actually fixing something :)

Sure and it is indeed a fix, just not for a regression or something
critical (oops, etc), and therefore the stable-cc tag was omitted.

> I'll drop it from everywhere, thanks.

Looks like you never dropped the preparatory clean ups. Should be ok.

Johan
