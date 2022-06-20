Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 340025517E9
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 13:59:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240545AbiFTL7N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 07:59:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235654AbiFTL7M (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 07:59:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32B98FDA
        for <stable@vger.kernel.org>; Mon, 20 Jun 2022 04:59:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C345361342
        for <stable@vger.kernel.org>; Mon, 20 Jun 2022 11:59:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA3A9C3411B;
        Mon, 20 Jun 2022 11:59:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655726351;
        bh=vk8p5kyyQYSfu5K1/2BM3pJaUjxuN3BqgHzGh0bAxsg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qb30QFfzmMfK+Q0Ev5NtM8iIDmP1afJljZGGzGUBtaGP4ebmYZu2Z8P1h3nShLqdu
         1JM4TrB2EKh+C8sAryfVVD/+MZahJIg04zBwsgdaLzBmYXhCwmDxgYMJFhzItKnqUk
         qCDNQ/92pBlpX6HBTfwHrfb1UsxBPoSbxY0ipQsg=
Date:   Mon, 20 Jun 2022 13:59:08 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc:     stable@vger.kernel.org
Subject: Re: backport of patches to fix riscv build failure in 4.19-stable
 and 5.4-stable
Message-ID: <YrBhDLT5jgZEnUbJ@kroah.com>
References: <YqeVUUsqCf9WPQ2S@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YqeVUUsqCf9WPQ2S@debian>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 13, 2022 at 08:51:45PM +0100, Sudip Mukherjee wrote:
> Hi Greg,
> 
> The build of riscv allmodconfig fails in 4.19-stable and 5.4-stable.
> 
> 4.19-stable will need:
> 	30aca1bacb39 ("RISC-V: fix barrier() use in <vdso/processor.h>")
> 
> and 5.4-stable needs:
> 	30aca1bacb39 ("RISC-V: fix barrier() use in <vdso/processor.h>")
> 	fc585d4a5cf6 ("riscv: Less inefficient gcc tishift helpers (and export their symbols)")
> 
> Backport of all are in the attached mbox.

All now queued up, thanks.

greg k-h
