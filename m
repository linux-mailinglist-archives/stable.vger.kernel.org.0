Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AE2845A530
	for <lists+stable@lfdr.de>; Tue, 23 Nov 2021 15:21:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237680AbhKWOY0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Nov 2021 09:24:26 -0500
Received: from new3-smtp.messagingengine.com ([66.111.4.229]:45077 "EHLO
        new3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237584AbhKWOYZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Nov 2021 09:24:25 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id 67B9758172E;
        Tue, 23 Nov 2021 09:21:17 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Tue, 23 Nov 2021 09:21:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=c9ZKjgRNScFEEV/g9e1Z5f3zy02
        1dtFpLJDQhZd1/RI=; b=LJVkSW+RRuqcE1axk0M62cALHgc+BN1Qo36C0IShkoh
        esTHbciFRQFyBtAibYdiyQBCEvrl34OTFmJ/1c6QQVXvtOg2mqSRPI9b8rrojSpw
        7ZxzjDyQTSP24CV/fL19zwYvkYfr12onn+t757SpnDN0z/8SNR2UfteVg4ymB31R
        qLE5Q4iyfySmi5UBAyuLdyJFZ6ZS6ZvxnYK6E4vbu/4eFaXidTcOOkPNjIevspEX
        Gw50XL/GCInCk/5Di93kdiVooYxP0XDhC4kdrIT+BdFlsvV23+IqLYgumlXjLOlg
        3oTr5d3hvQfxkc9V4NrCsEAX+YIjkTCLfH0+6zNWgGQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=c9ZKjg
        RNScFEEV/g9e1Z5f3zy021dtFpLJDQhZd1/RI=; b=L72/KiQAh81f5WDpW2Oab0
        J5b1VC9wrCu5DnbjQL6BkcVP6CvEpekQ9lBLvv19VikXtGExUQyKUTEdWBzmB6W8
        5k5ajCDIKYED3dUcFcAXNKP0tW8RcCMGr3lQdrPHnOw1HmwqLxfOjTfpe2khVO9k
        sWdEv11HjyFId2LTr0DqJMTZvjQpwTE4qvKT2wA2vHRrsYwhR+8Qwh7Mk0rDzxrz
        QOp8sx91Llf/zqSGCkKZfWPHq2ISDWIYWkSCpBn+X4v6QRzzqAUUKsKphUquu1ZE
        5theDyqEfBMgJNVLnG3OYTosz7Wx1Os/P0jDSw2efQRIMO7wDCSkbPc0TSY9F4Kw
        ==
X-ME-Sender: <xms:3ficYWMOItT3e8mGHq7taKXRwZmKZy5XKvDBsQE2WYS_z9YAW0gaXA>
    <xme:3ficYU8up1DuuYZr52XHCyFVeJRDHH8QtA3wufsyciFdLXhISyeGaa5DugNCBitED
    IFKWMJ8Ed1kGg>
X-ME-Received: <xmr:3ficYdQJ_rRCULELzjpP97aZmiY9S4Hikj-1zboePu8XKfcatItpSVEyZpSd6q3K-B-Na_zdEhqrlXNe5n9h5yjLvZqMf5ai>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvuddrgeeigdeigecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghgucfm
    jfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepueelledthe
    ekleethfeludduvdfhffeuvdffudevgeehkeegieffveehgeeftefgnecuffhomhgrihhn
    pehkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:3ficYWsTUnnpqyF6CXwKcXnLFe3ef6b7hURw4K8xDmN9GAbikM_Wuw>
    <xmx:3ficYecqTFK9fzAGsfI3VCwyOZlL-AYcjgV-g92Y14xoWCSxUENoDg>
    <xmx:3ficYa1q1NgZ_uoFsfbby107S7SRW7G3rhZBo0lHelac3TD4bDQMkQ>
    <xmx:3ficYU2Vyy8cVffKkg7HYjmiNI2UwMsO-PsB9YOLlG8EOketFIwImA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 23 Nov 2021 09:21:16 -0500 (EST)
Date:   Tue, 23 Nov 2021 15:21:14 +0100
From:   Greg KH <greg@kroah.com>
To:     Stephan Gerhold <stephan@gerhold.net>
Cc:     Sasha Levin <sashal@kernel.org>, stable-commits@vger.kernel.org,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, stable@vger.kernel.org
Subject: Re: Patch "arm64: dts: qcom: msm8916: Add CPU ACC and SAW/SPM" has
 been added to the 5.15-stable tree
Message-ID: <YZz42jodqbYIbm4e@kroah.com>
References: <20211121230414.76410-1-sashal@kernel.org>
 <YZzpHOrS8IHE6mRm@gerhold.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YZzpHOrS8IHE6mRm@gerhold.net>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 23, 2021 at 02:14:04PM +0100, Stephan Gerhold wrote:
> Hi Sasha,
> 
> On Sun, Nov 21, 2021 at 06:04:14PM -0500, Sasha Levin wrote:
> > This is a note to let you know that I've just added the patch titled
> > 
> >     arm64: dts: qcom: msm8916: Add CPU ACC and SAW/SPM
> > 
> > to the 5.15-stable tree which can be found at:
> >     http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
> > 
> > The filename of the patch is:
> >      arm64-dts-qcom-msm8916-add-cpu-acc-and-saw-spm.patch
> > and it can be found in the queue-5.15 subdirectory.
> > 
> > If you, or anyone else, feels it should not be added to the stable tree,
> > please let <stable@vger.kernel.org> know about it.
> > 
> 
> Did you forget to drop this patch? :)
> 
> You mentioned that you did [1] (since I replied that this patch is not
> useful without other changes in 5.16), but apparently not. ;)

I've deleted it now from 5.15 and 5.10 queues.

thanks,

greg k-h
