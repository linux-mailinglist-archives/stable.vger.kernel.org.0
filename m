Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F06C18C9A4
	for <lists+stable@lfdr.de>; Fri, 20 Mar 2020 10:12:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726690AbgCTJMy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Mar 2020 05:12:54 -0400
Received: from mail-ua1-f65.google.com ([209.85.222.65]:38290 "EHLO
        mail-ua1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726232AbgCTJMy (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Mar 2020 05:12:54 -0400
Received: by mail-ua1-f65.google.com with SMTP id h35so1906406uae.5
        for <stable@vger.kernel.org>; Fri, 20 Mar 2020 02:12:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pSNXmkoOUtbGfWIR1TmNY7fMvDVY9NR6X4BkPQ5g2xU=;
        b=lw7zi2tJQmoJ1dkG5Zoyho/dstx+PY7NsNxvj1uLJgk3xhmzbwxeGR7wQptQPYVEAl
         NdU4jK7y18NVW2+CgL8gtbn/MCVRup1wAjHIgsN/MUXGW1SrlqlajhrYKBc5IhsrrJK7
         IznxDJPQXXJF14Hw+swUb4SYQ10dT87h0/7pE8m04lC6XWOEjROmHPcBOACz8tD2VKmh
         hx82dGrVo2NWuyw1xeYV1YUMKBTFXfzCRbu0QQneWJD+ol4UJIEoXLdegmDtLUKR53pk
         tG3uQy50mR1VdjUP1NjCBqL4W2ZGGOpA1lKWoY/8QllqagNtXqbKDjZPTUnAYCeybucE
         OuXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pSNXmkoOUtbGfWIR1TmNY7fMvDVY9NR6X4BkPQ5g2xU=;
        b=LF1NyDhV5WPjndqwMNmqoOWzpOSBs/hPn1UfayveISNs+kPduPOfqCWocqoXA6UFxC
         DRD8Ug578P4A2PlG2w6P0c3FlAOCLn9iMOtCGn4HwNwYgpVCTAxxXHXAmt4tl5c+IP+q
         iWWwIKMpLoxH7B/h9ldKNO3hEkxkueQcW/gs2BIUHqZWpxXd2hW69hYST+iGqEqgKkWc
         yec53TtBqopi0aeMHokVlorxFWMMxZmA0ctul1XcANMIQX3wYwwaiBGGdVDme9nWod+c
         Jl2O2PO/tITIr85KRxj3TCVHUqninc3gc6tdBWYDhwK0Nm2Mk5NgcTYBSFtgJB8ygEEW
         q6AA==
X-Gm-Message-State: ANhLgQ1iRfFJw65WbZ9P5n+Zigfms+VLBM33uqEuLMFuBr+E6IWFpKxg
        4ybskI5VTtiX9NFp0qIkywyVxYbu06aDOG69l5wsxw==
X-Google-Smtp-Source: ADFU+vs2Rv7sPVsohQsxbQ/OYh/lvY43FkHC1nxYr8JsS+Y77jOjc/XPKiJUmrOGA5nj4BY+oQUue+eJN4qrwFjtSHw=
X-Received: by 2002:ab0:7381:: with SMTP id l1mr4973983uap.104.1584695571544;
 Fri, 20 Mar 2020 02:12:51 -0700 (PDT)
MIME-Version: 1.0
References: <158435827821152@kroah.com> <20200318192528.GH4189@sasha-vm>
In-Reply-To: <20200318192528.GH4189@sasha-vm>
From:   Ulf Hansson <ulf.hansson@linaro.org>
Date:   Fri, 20 Mar 2020 10:12:15 +0100
Message-ID: <CAPDyKFp2zX5Zij4bCRuOrxBzgpyH9n2Ee3rNBVkm46n8R5DfNA@mail.gmail.com>
Subject: Re: FAILED: patch "[PATCH] mmc: core: Allow host controllers to
 require R1B for CMD6" failed to apply to 5.5-stable tree
To:     Sasha Levin <sashal@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Anders Roxell <anders.roxell@linaro.org>,
        Faiz Abbas <faiz_abbas@ti.com>,
        Peter Geis <pgwipeout@gmail.com>,
        Sowjanya Komatineni <skomatineni@nvidia.com>,
        "# 4.0+" <stable@vger.kernel.org>,
        Naresh Kamboju <naresh.kamboju@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

+ Naresh

On Wed, 18 Mar 2020 at 20:25, Sasha Levin <sashal@kernel.org> wrote:
>
> On Mon, Mar 16, 2020 at 12:31:18PM +0100, gregkh@linuxfoundation.org wrote:
> >
> >The patch below does not apply to the 5.5-stable tree.
> >If someone wants it applied there, or to any other stable or longterm
> >tree, then please email the backport, including the original git commit
> >id to <stable@vger.kernel.org>.
> >
> >thanks,
> >
> >greg k-h
> >
> >------------------ original commit in Linus's tree ------------------
> >
> >From 1292e3efb149ee21d8d33d725eeed4e6b1ade963 Mon Sep 17 00:00:00 2001
> >From: Ulf Hansson <ulf.hansson@linaro.org>
> >Date: Tue, 10 Mar 2020 12:49:43 +0100
> >Subject: [PATCH] mmc: core: Allow host controllers to require R1B for CMD6
> >
> >It has turned out that some host controllers can't use R1B for CMD6 and
> >other commands that have R1B associated with them. Therefore invent a new
> >host cap, MMC_CAP_NEED_RSP_BUSY to let them specify this.
> >
> >In __mmc_switch(), let's check the flag and use it to prevent R1B responses
> >from being converted into R1. Note that, this also means that the host are
> >on its own, when it comes to manage the busy timeout.
> >
> >Suggested-by: Sowjanya Komatineni <skomatineni@nvidia.com>
> >Cc: <stable@vger.kernel.org>
> >Tested-by: Anders Roxell <anders.roxell@linaro.org>
> >Tested-by: Sowjanya Komatineni <skomatineni@nvidia.com>
> >Tested-by: Faiz Abbas <faiz_abbas@ti.com>
> >Tested-By: Peter Geis <pgwipeout@gmail.com>
> >Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
>
> I've fixed up and queued this whole mmc series of stable tagged patches
> for 4.19-5.5.

I looked at stable-rc tree and realized that you have also picked the
following patch:

commit 533a6cfe08f96a7b5c65e06d20916d552c11b256
Author: Ulf Hansson <ulf.hansson@linaro.org>
Date:   Wed Jan 22 15:27:47 2020 +0100
mmc: core: Default to generic_cmd6_time as timeout in __mmc_switch()

I assume this one was needed to apply the others mmc patches on top.
This is a problem, because the above patch should not go for stable as
it causes problems (unless additional patches are backported as well).

I suggest to drop the whole slew of mmc patches for the current stable
rcs. Then I can send manual backports instead, is that okay?

Kind regards
Uffe
