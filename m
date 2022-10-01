Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F08D5F1A68
	for <lists+stable@lfdr.de>; Sat,  1 Oct 2022 08:59:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229516AbiJAG7J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 1 Oct 2022 02:59:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229495AbiJAG7I (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 1 Oct 2022 02:59:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B1CA2655C
        for <stable@vger.kernel.org>; Fri, 30 Sep 2022 23:59:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D011AB80B27
        for <stable@vger.kernel.org>; Sat,  1 Oct 2022 06:59:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1982EC433D6;
        Sat,  1 Oct 2022 06:59:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664607544;
        bh=betVsquWI8ZtvV7tDK44KykuaK76IStGJiTr1zn8O/I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=j0dLMovjb7VsO6COok7VNfXNmbMsSQv73ArpewtQ0YIQc+yRqjAjU/jpsYy3tlc8b
         QqVQykhFzCx3XVHtX4mn5vw5TKBU5N3ZIvcWYZXVa3q3F5w/s+7iihof9xmR1CD0zF
         98JaQ8P6u3S5FgaTXgV3giDWDT7CBVcfxIbL56gE=
Date:   Sat, 1 Oct 2022 08:59:41 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Mikulas Patocka <mpatocka@redhat.com>
Cc:     stable@vger.kernel.org
Subject: Re: backport of patches 8238b4579866b7c1bb99883cfe102a43db5506ff and
 d6ffe6067a54972564552ea45d320fb98db1ac5e
Message-ID: <YzflXQMdGLsjPb70@kroah.com>
References: <alpine.LRH.2.02.2209301128030.23900@file01.intranet.prod.int.rdu2.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.2209301128030.23900@file01.intranet.prod.int.rdu2.redhat.com>
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Sep 30, 2022 at 11:32:30AM -0400, Mikulas Patocka wrote:
> Hi
> 
> Here I'm submitting backport of patches 
> 8238b4579866b7c1bb99883cfe102a43db5506ff and 
> d6ffe6067a54972564552ea45d320fb98db1ac5e to the stable branches.

Thanks, but you provide no information as to why these are needed.

What needs them?  They are just adding new functions to the tree from
what I can tell.

thanks,

greg k-h
