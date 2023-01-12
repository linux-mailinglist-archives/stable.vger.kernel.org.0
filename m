Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CE7C66728F
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 13:49:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231396AbjALMtU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 07:49:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230375AbjALMtO (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 07:49:14 -0500
Received: from out5-smtp.messagingengine.com (out5-smtp.messagingengine.com [66.111.4.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EBF74C70D
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 04:49:13 -0800 (PST)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 43B0A5C00F5;
        Thu, 12 Jan 2023 07:49:10 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Thu, 12 Jan 2023 07:49:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm3; t=1673527750; x=1673614150; bh=UOt//9rBmC
        9zXmXXsruIPeqvipqSRenmwAYz0YoEh7A=; b=fqC5CGU/Gi3c7FHTyGUwsvTazS
        QWhKGrzSAWw5vtsLa8dyowRo+SKQR45r2NmEEFlgiZicoQr+NnbdtFteZyA6dQ3i
        VhxFxqmOuGhi0cBYvexit1x1UnMdmWri3SRUcRroXo/3QZ8j8kIF2nqBr5yYEXLX
        c6AHGxuJo0UBrB7ExzMM9jxddMKXbLdK+GspVedOWBrRQTqRF8AsDuoL58t3phuu
        WtW3BGnFkBeZtq1wMS/jcHs165cdhZnASfeC7AX1j53QN8WfQbG+qdpHqkGJxHA+
        vw2A4jXwPSyfooRp2nSjjuqkl1pKqhoTKbj3WGvoqKyApezN8uFhxXfb8huQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; t=1673527750; x=1673614150; bh=UOt//9rBmC9zXmXXsruIPeqvipqS
        RenmwAYz0YoEh7A=; b=cHdnCclOBjaXMMtfLXv9/NViDyjxU+ePB1myTTF+Nvcb
        XXNc+QeFNtadt4K7nmt9fQ8pAtsXJlxjEKTHcHVDdMUxb1ZEqqIzYN8L1+wN67V0
        gWpoYm+HanIvii8wP5EkEqAM8r4ABXBIsoCKtLcrypf85Y70eonJyGAyEVonC3PD
        lqmVcP/+Dz3CT00Wk/77PyGFD1ejjmn/i9xJl1lSdVpxALp0pR1KhwlgbCX6Gys3
        z/ufIM0J2wn9DlN4j1uXNkrMR5bwwyYpK3DU7gmU8OJSIKX+WC6WXzOtYAH3T2Ky
        2cVJkDHol3GPVH89We3sVi/MMNZJHNEyx0QxjiKMXw==
X-ME-Sender: <xms:xgHAY7YFsxqZ_RRTprchr5bJtr_t4V1d3q4LAJQecaZ9WG3xry8yCw>
    <xme:xgHAY6YOGZWlu0MGX_k97imbRVXfVikEx2La21-Vfa692pNDwgs1Y-TbnVgqHxMyo
    u14SwryASlqWg>
X-ME-Received: <xmr:xgHAY9-4PGtYGPS5ZG98G4U9jCSXPzZeMdgz83SGEgvR57bi4rPyRW8jb4kuByE2fpgTNGeud7I3TG0CvD0Xrgduhdqmcl_vbhPMhg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrleeigdeggecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeehgedvve
    dvleejuefgtdduudfhkeeltdeihfevjeekjeeuhfdtueefhffgheekteenucevlhhushht
    vghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:xgHAYxp9akukf5LyWYfiGMn8G3uC58VI1ybHlurX0ZXAsLAMAGc94A>
    <xmx:xgHAY2pk-OTKzdI1UqbLh_uRx59nbR7BvMUo7Y9SlUMfpmGX25X6jw>
    <xmx:xgHAY3SZmKaCDLfYwMcLSYGD8_BgN6U0Wex9XCX2Y50WGZ40C7DypQ>
    <xmx:xgHAY3dEZa-b58TIDkirjVO9-BOW7xbfQoI88Ey9lO2Wymf5XKYP1g>
Feedback-ID: i787e41f1:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 12 Jan 2023 07:49:09 -0500 (EST)
Date:   Thu, 12 Jan 2023 13:49:07 +0100
From:   Greg KH <greg@kroah.com>
To:     Tyler Hicks <code@tyhicks.com>
Cc:     stable@vger.kernel.org, Shuah Khan <skhan@linuxfoundation.org>,
        Muhammad Usama Anjum <usama.anjum@collabora.com>
Subject: Re: [PATCH 5.4 0/2] Fix kselftest builds when specifying an output
 dir
Message-ID: <Y8ABw2lEdVtxXk01@kroah.com>
References: <20230106220844.763870-1-code@tyhicks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230106220844.763870-1-code@tyhicks.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 06, 2023 at 04:08:42PM -0600, Tyler Hicks wrote:
> From: "Tyler Hicks" <code@tyhicks.com>
> 
> When attempting to build kselftests with a separate output directory, a
> number of the tests fail to build.
> 
> For example,
> 
>  $ rm -rf build && \
>    make INSTALL_HDR_PATH=build/usr headers_install > /dev/null && \
>    make O=build FORCE_TARGETS=1 TARGETS=breakpoints -C tools/testing/selftests > /dev/null
>  /usr/bin/ld: cannot open output file
>  build/kselftest/breakpoints/step_after_suspend_test: No such file or directory
>  collect2: error: ld returned 1 exit status
>  make[1]: *** [../lib.mk:146: build/kselftest/breakpoints/step_after_suspend_test] Error 1
>  make: *** [Makefile:163: all] Error 2
> 
> This has already been addressed upstream with v5.18 commit 5ad51ab618de
> ("selftests: set the BUILD variable to absolute path"). It does not
> cleanly cherry pick to the linux-5.4.y branch without v5.7 commit
> 29e911ef7b70 ("selftests: Fix kselftest O=objdir build from cluttering
> top level objdir"). Commit 5ad51ab618de was written in a way that
> assumes that the kselftests aren't build in the top level objdir so it
> makes sense to bring the pre-req commit back but it does represent a
> slight change in behavior since the kselftests will now be built in a
> subdir of the specified objdir (O=). 
> 
> Tyler
> 
> Muhammad Usama Anjum (1):
>   selftests: set the BUILD variable to absolute path
> 
> Shuah Khan (1):
>   selftests: Fix kselftest O=objdir build from cluttering top level
>     objdir
> 
>  tools/testing/selftests/Makefile | 28 ++++++++++++++++++----------
>  1 file changed, 18 insertions(+), 10 deletions(-)
> 
> -- 
> 2.34.1
> 

Now queued up, thanks.

greg k-h
