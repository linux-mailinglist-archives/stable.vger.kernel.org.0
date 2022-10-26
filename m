Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7333960E3CE
	for <lists+stable@lfdr.de>; Wed, 26 Oct 2022 16:54:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233472AbiJZOy2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Oct 2022 10:54:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232823AbiJZOy1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Oct 2022 10:54:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1020D5599
        for <stable@vger.kernel.org>; Wed, 26 Oct 2022 07:54:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7DF2061EE4
        for <stable@vger.kernel.org>; Wed, 26 Oct 2022 14:54:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 940F9C433C1;
        Wed, 26 Oct 2022 14:54:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666796064;
        bh=Wm/buBkq5yH2oh2nH3wz/NiMFlhTmgt7KwLkHQRgBK0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HxFFA7adCkZie3vjcep36qATdTdeMJLqW3hdIPpEhFv3chI7V2rTWu8ojzAv6ZksU
         iaI/VCL3yTRlOuu5wOR2bAWO4hua1RVt0nLYK2XBpUQgRF92NIDAnif8/hru/4mxz1
         7X0f1VpG3PtsGg89oPXDbPbohdCSzwEksLtuNYx4=
Date:   Wed, 26 Oct 2022 16:54:22 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     James Smart <jsmart2021@gmail.com>
Cc:     stable@vger.kernel.org, justintee8345@gmail.com,
        martin.petersen@oracle.com
Subject: Re: [PATCH 01/33] Revert "scsi: lpfc: Resolve some cleanup issues
 following SLI path refactoring"
Message-ID: <Y1lKHhn0MGkJfx35@kroah.com>
References: <20221025225739.85182-1-jsmart2021@gmail.com>
 <20221025225739.85182-2-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221025225739.85182-2-jsmart2021@gmail.com>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 25, 2022 at 03:57:07PM -0700, James Smart wrote:
> This reverts commit 17bf429b913b9e7f8d2353782e24ed3a491bb2d8.
> ---

For obvious reasons, I can't take patches with no changelog text, no
explainion, AND no signed-off-by :(

Please fix up and resend the revert series and I will be glad to take
them.

thanks,

greg k-h
