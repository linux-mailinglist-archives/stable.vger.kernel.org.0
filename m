Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3045661312F
	for <lists+stable@lfdr.de>; Mon, 31 Oct 2022 08:26:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229816AbiJaH0E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Oct 2022 03:26:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229720AbiJaH0D (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Oct 2022 03:26:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78B226581
        for <stable@vger.kernel.org>; Mon, 31 Oct 2022 00:26:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2A3A9B810B2
        for <stable@vger.kernel.org>; Mon, 31 Oct 2022 07:26:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81951C433D6;
        Mon, 31 Oct 2022 07:25:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667201159;
        bh=snfp/1uDp3AgCrGG0EbcLKN79e6a0/gYKxZ7klPaZiQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cj/PvH2xVzD1G3Vd2shhTFC0mfnFQlTpn1nziuKBuEpNy4YWkPuQAQ2IwI4O/AFU3
         cG7JC3LMN8WdgUtV42Fm1wfxEHmzoBu3LQIJ5IdBF6sOJAERFbcGjtaPSiMMcjZfq3
         G+PI1kY3pPRHPuhJSqkG5DOyHaF/TTRIJzMa0szc=
Date:   Mon, 31 Oct 2022 08:26:45 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     James Smart <jsmart2021@gmail.com>
Cc:     stable@vger.kernel.org, justintee8345@gmail.com,
        martin.petersen@oracle.com
Subject: Re: [PATCH v2 0/6] lpfc: LTS 5.15 update to correct path split
 changes
Message-ID: <Y194tUNlsWa+MpYU@kroah.com>
References: <20221028210827.23149-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221028210827.23149-1-jsmart2021@gmail.com>
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Oct 28, 2022 at 02:08:21PM -0700, James Smart wrote:
> An issue was identified with lpfc in the LTS 5.15 kernel. There is an
> FLOGI failure which prevents FC link bringup.
> 
> In the past several kernel releases, we have been reworking areas of
> the driver to fix issues in the broader design rather than continuing
> to create a patchwork on an issue-by-issue basis. This means there are
> a lot of inter-related patches.
> 
> In this case, it appears that a portion of the "path split" rework was
> pulled into 5.15, and the portion that wasn't picked up introduced
> the error.
> 
> This patch set reverts the patches for the partial pull in.

All now queued up, thanks.

greg k-h
