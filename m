Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95AD3595B38
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 14:06:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232431AbiHPMGB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 08:06:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235555AbiHPMF3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 08:05:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 750AC83068
        for <stable@vger.kernel.org>; Tue, 16 Aug 2022 04:54:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1961E611EF
        for <stable@vger.kernel.org>; Tue, 16 Aug 2022 11:54:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16A3BC433D6;
        Tue, 16 Aug 2022 11:54:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660650881;
        bh=BHb6mXzPEQ5XXr2T9L+j4EttEtyEg8noaOLOy8NerTE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=xWnp/fpSslbvfkGoO2EhFtXAvcf/yt5ysokcRVESfPUwhshNMUQlLchd6hb0M2z4q
         W/ZHSrQNUXQvNTNZ4m14kJTkEDSVZ3fbxCd8xT1h97Me1rmIgLGQTHv762Qmt9XYeB
         TFS2IIdQpU9DYMsj69NTMV5yCPqqHg/XU2z/bFIo=
Date:   Tue, 16 Aug 2022 13:54:38 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     cki-project@redhat.com
Cc:     stable@vger.kernel.org
Subject: Re: =?utf-8?B?4p2MIEZBSUw=?= =?utf-8?Q?=3A?= Test report for
 122bb8ac (stable-queue)
Message-ID: <YvuFfp/wfn4UFYpn@kroah.com>
References: <92005.122081607111901341@us-mta-567.us.mimecast.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <92005.122081607111901341@us-mta-567.us.mimecast.lan>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 16, 2022 at 11:11:18AM -0000, cki-project@redhat.com wrote:
> Hi, we tested your kernel and here are the results:
> 
>     Overall result: FAILED
>              Merge: OK
>            Compile: FAILED
> 
> 
> You can find all the details about the test run at
>     https://datawarehouse.cki-project.org/kcidb/checkouts/41055
> 
> One or more kernel builds failed:
>     Unrecognized or new issues:
>           x86_64 - https://datawarehouse.cki-project.org/kcidb/builds/218267

Am I going to be forced to click through to find out the problems with
all of these reports?  Why not provide the error log?

The error log isn't at that link, where are we supposed to find it to
figure out what went wrong?

> If you find a failure unrelated to your changes, please tag it at https://datawarehouse.cki-project.org .
> This will prevent the failures from being incorrectly reported in the future.
> If you don't have permissions to tag an issue, you can contact the CKI team or
> test maintainers.
> 
> Please reply to this email if you have any questions about the tests that we
> ran or if you have any suggestions on how to make future tests more effective.
> 
>         ,-.   ,-.
>        ( C ) ( K )  Continuous
>         `-',-.`-'   Kernel
>           ( I )     Integration
>            `-'
> ______________________________________________________________________________
> 

I have no idea what the subject line means, sorry.  A random git commit
id with no context isn't helpful, what are we to do with that?

thanks,

greg k-h
