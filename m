Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEBE16EBE98
	for <lists+stable@lfdr.de>; Sun, 23 Apr 2023 12:27:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229477AbjDWK1k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 23 Apr 2023 06:27:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229464AbjDWK1j (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 23 Apr 2023 06:27:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D854210CC
        for <stable@vger.kernel.org>; Sun, 23 Apr 2023 03:27:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 71B7F617B8
        for <stable@vger.kernel.org>; Sun, 23 Apr 2023 10:27:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65158C433EF;
        Sun, 23 Apr 2023 10:27:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1682245657;
        bh=NCIhCEFI96tPM4ZSHbqTZGUvNCqCPKgdEaukIG6aWBs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SO7ShYl1UmjuXEJtQuwEVAH4tiH5seUZZFV50pYezwxHhJD4DqRfr89vCymOcF9K1
         6U2jC6gHwxoDLoWajKIN03estC7XUPgnaSmnmqDLPORT7k9aHdmRYf6ObyMXwaWWKg
         +dlZ3f69GbB7M/izQLoax9rGZUEuf4GrGqFrJQqI=
Date:   Sun, 23 Apr 2023 12:27:34 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Huacai Chen <chenhuacai@kernel.org>
Cc:     chenhuacai@loongson.cn, kernel@xen0n.name, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] LoongArch: Make WriteCombine configurable
 for ioremap()" failed to apply to 6.2-stable tree
Message-ID: <2023042322-eraser-coastal-6124@gregkh>
References: <2023042213-overbid-jitters-7a29@gregkh>
 <CAAhV-H5wPvRtf0uBnyzUnwpgnfU3oB4mezHQ6L7AzyvgHPTU8w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAhV-H5wPvRtf0uBnyzUnwpgnfU3oB4mezHQ6L7AzyvgHPTU8w@mail.gmail.com>
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Apr 23, 2023 at 10:56:16AM +0800, Huacai Chen wrote:
> Hi, Greg,
> 
> If possible, we can backport 41596803302d ("LoongArch: Make
> -mstrict-align configurable") as a dependency patch.

Thanks, that worked for 6.2.y, but not 6.1.y

greg k-h
