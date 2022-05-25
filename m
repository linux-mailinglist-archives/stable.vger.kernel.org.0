Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 901C1533EC5
	for <lists+stable@lfdr.de>; Wed, 25 May 2022 16:07:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242353AbiEYOHl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 May 2022 10:07:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243948AbiEYOH1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 25 May 2022 10:07:27 -0400
Received: from out1-smtp.messagingengine.com (out1-smtp.messagingengine.com [66.111.4.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 925DBAB0CD
        for <stable@vger.kernel.org>; Wed, 25 May 2022 07:07:09 -0700 (PDT)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id F12FB5C016C;
        Wed, 25 May 2022 10:07:08 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Wed, 25 May 2022 10:07:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm1; t=1653487628; x=1653574028; bh=RTanVjdOt6
        B7TY1l35UYbSRcLK4clrYoICGHFSKQusM=; b=I3kEtyHKWcdOvAU7Yt1WRZJPAK
        +5HHzSMvqpD+mU3qMvr5Mw9BKPcnLPVVH7uIPEQQjUTxRboL7TFA7CPVy0srqjXD
        pTtY4fp386cfmB0irEK5wQCSRg2A6JHeQ0LE4Z58eMhN04afHaEIjuzzNPQ1ou5F
        k7JD0fpo+FfmtgPNIkRrOmjPa4zGBoOMaYLXdFmzMHvBMSOEtwkUHgWywLY1xoIC
        MzyW8AzhnhaOJ/mPxVhvGlYcphxXRjsSq3dXAp3+zpWoxORU68t1bCjVYTrmml5a
        nItIE97sDrgCQVRyksxhQW6TWpHExN7x/Z9IVRMFehjtJXI9NCl5SA4LfxIg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; t=1653487628; x=1653574028; bh=RTanVjdOt6B7TY1l35UYbSRcLK4c
        lrYoICGHFSKQusM=; b=aB811JCR5XvFkV/yvVe44c9mRJnTWNXBJN3q3h9LEXDe
        oOuZAIdAwMK+kPgwoAq8jojfKIMBYdt/wS9TgPKlRn2w6YycPYffucOkNhnVUvtB
        fj3LbapkUpz+STo98XeHkmsdWzcOxOlnfHgW2zwxwPmlPvAx2Eg/z723Kf13tmVo
        Mj5OOWcijsjCtUPQenRaSS+SP1TkOVrnvbL4Uokw6TL8l9YkGUMrMNvGG/T1Q0s7
        Rnr2oQSY9WErX1LM7lwp1MVEjPaQKNG/d2dvOqHRUp5u1yuCuW1k/OuPS2xZCkKU
        8jd5KBGklc8RxF2l6/h5n5bZ0neYTu+A1JlC9dOatA==
X-ME-Sender: <xms:CziOYpaWCuZI_eRDh-5qJUrhvlkadBIYtEHRs7F7Bbh9esfGXYtazA>
    <xme:CziOYgb-CqSbpl2BMUEdzN9e-73XszetSyLiz7k3_yt-KNnU1Pu6HmxpJk36Ldpk0
    NlDaX9IxMUh_Q>
X-ME-Received: <xmr:CziOYr_kzxF8B4zJYdo4e_cNgNiP2CnhboIR5UJUTmj2BnBtzlVEUoA9GA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrjeehgdejtdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeehgedvve
    dvleejuefgtdduudfhkeeltdeihfevjeekjeeuhfdtueefhffgheekteenucevlhhushht
    vghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:CziOYnpr_yMpRtOOA5DVmijiJavVEOvCRzMjVGhpfWS2Y45-f5dwaw>
    <xmx:CziOYkojDOtaExBG359dPuKfVtetMFpgJKjYmEowd5tLxpbo_UsYFQ>
    <xmx:CziOYtQe_jBx7ZEgK8UAUHORUvoq1foAQiZR_jP-TGjLD4W2EYFw_g>
    <xmx:DDiOYhgcShS21pPvikTWP4BPI4Wu0muGbN_kKAfCGoedk8_uHXAeWA>
Feedback-ID: i787e41f1:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 25 May 2022 10:07:07 -0400 (EDT)
Date:   Wed, 25 May 2022 15:51:13 +0200
From:   Greg KH <greg@kroah.com>
To:     Daniel Thompson <daniel.thompson@linaro.org>
Cc:     stable@vger.kernel.org, Jason Wessel <jason.wessel@windriver.com>,
        Douglas Anderson <dianders@chromium.org>,
        Stephen Brennan <stephen.s.brennan@oracle.com>,
        Konrad Wilk <konrad.wilk@oracle.com>
Subject: Re: [PATCH v5.4] lockdown: also lock down previous kgdb use
Message-ID: <Yo40UeUyNGxMuV18@kroah.com>
References: <20220525133107.204183-1-daniel.thompson@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220525133107.204183-1-daniel.thompson@linaro.org>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 25, 2022 at 02:31:07PM +0100, Daniel Thompson wrote:
> commit eadb2f47a3ced5c64b23b90fd2a3463f63726066 upstream.
> 
> KGDB and KDB allow read and write access to kernel memory, and thus
> should be restricted during lockdown.  An attacker with access to a
> serial port (for example, via a hypervisor console, which some cloud
> vendors provide over the network) could trigger the debugger so it is
> important that the debugger respect the lockdown mode when/if it is
> triggered.
> 
> Fix this by integrating lockdown into kdb's existing permissions
> mechanism.  Unfortunately kgdb does not have any permissions mechanism
> (although it certainly could be added later) so, for now, kgdb is simply
> and brutally disabled by immediately exiting the gdb stub without taking
> any action.
> 
> For lockdowns established early in the boot (e.g. the normal case) then
> this should be fine but on systems where kgdb has set breakpoints before
> the lockdown is enacted than "bad things" will happen.
> 
> CVE: CVE-2022-21499
> Co-developed-by: Stephen Brennan <stephen.s.brennan@oracle.com>
> Signed-off-by: Stephen Brennan <stephen.s.brennan@oracle.com>
> Reviewed-by: Douglas Anderson <dianders@chromium.org>
> Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
> Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> ---
> 
> Notes:
>     Original patch did not backport cleanly. This backport is fixed up,
>     compile tested (on arm64) and side-by-side compared against the
>     original.
> 

Now queued up, thanks.

greg k-h
