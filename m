Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 418808D8AE
	for <lists+stable@lfdr.de>; Wed, 14 Aug 2019 19:01:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727814AbfHNRBM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Aug 2019 13:01:12 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:39952 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727558AbfHNRBL (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Aug 2019 13:01:11 -0400
Received: by mail-pl1-f195.google.com with SMTP id a93so50897790pla.7
        for <stable@vger.kernel.org>; Wed, 14 Aug 2019 10:01:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=5oGQis/F/3P2NPlpUuR9C1B40kLmzuezbByNK7rhDpk=;
        b=WZF49giSB39rmMI0uePY6XUC47A4q8RW9V1ECnQCZe2vOl2f+R3+2Hho/yZaRhzVIi
         xJlSRGJ4vCcjZ3Nb829sFj2912KTiNMl/ZPwcQZRVcSCY1FmTcLB6S4TWN4ly6wswoij
         W5GLWAswgVcKqX6cr85DzXwzj0IjigpHSNv10=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=5oGQis/F/3P2NPlpUuR9C1B40kLmzuezbByNK7rhDpk=;
        b=sjzVGCHbjPM/a/ysSkM/1j47EQQvK6a6LoRKgGDMc6HuTHVyeGGuGEF3fUPjwSfoLB
         7DmfG+6+JjYB055YUHS6VJqpdgH82pV46KBvSebR7SMzwWCuia8ls0xLRI9TGY4h8mm/
         GnopBwZgrNoCu0F/lowrALmOSfb/AHMj1VLBLQe4DDJJVEjOHz/aAwwg6S+AzX/0Hm56
         kCgH0+HGuwvNAekiNV8eHR2l15BZJWNNo4PNBXMVEZYq7Cz2m6La6dKDOvacsZjutVKr
         NsE8Nks+7+7IsrBin1OnttKmQz7+V3qXVTfzrtfPnttkFxjUo3CKzkRCKO1mpqIGXBqj
         FT3A==
X-Gm-Message-State: APjAAAUqi0p+gY67PYUEg2GFJ1+PY9dmMVuw2uawkzyKbQ/VPwSVJTaN
        vBqRN17RUxiUBWCS+PvZZo/WVA==
X-Google-Smtp-Source: APXvYqy2ny/g4ymE3eOANxmOw+DqanvTWBl6Ht++LBRHPPvhj7LSoRrb8zefZDlGa9a1Uw4NzN6HBg==
X-Received: by 2002:a17:902:6b81:: with SMTP id p1mr357318plk.91.1565802071109;
        Wed, 14 Aug 2019 10:01:11 -0700 (PDT)
Received: from google.com ([2620:15c:202:1:534:b7c0:a63c:460c])
        by smtp.gmail.com with ESMTPSA id y22sm368864pfo.39.2019.08.14.10.01.09
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 14 Aug 2019 10:01:10 -0700 (PDT)
Date:   Wed, 14 Aug 2019 10:01:08 -0700
From:   Brian Norris <briannorris@chromium.org>
To:     gregkh@linuxfoundation.org
Cc:     kvalo@codeaurora.org, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] mwifiex: fix 802.11n/WPA detection"
 failed to apply to 4.4-stable tree
Message-ID: <20190814170107.GA117122@google.com>
References: <1565800055929@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1565800055929@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

n Wed, Aug 14, 2019 at 06:27:35PM +0200, Greg Kroah-Hartman wrote:
> The patch below does not apply to the 4.4-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

The conflicts were small, so I fixed and sent here:

https://lore.kernel.org/stable/20190814165914.143238-1-briannorris@chromium.org/T/#u

It'd be a shame to leave this broken on 4.4.y.

Brian
