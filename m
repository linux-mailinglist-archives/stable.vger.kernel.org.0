Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 737586BC8F0
	for <lists+stable@lfdr.de>; Thu, 16 Mar 2023 09:23:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229950AbjCPIXk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Mar 2023 04:23:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229581AbjCPIXj (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Mar 2023 04:23:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A7E4A8EA7
        for <stable@vger.kernel.org>; Thu, 16 Mar 2023 01:23:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3072AB815DF
        for <stable@vger.kernel.org>; Thu, 16 Mar 2023 08:23:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B2C7C433D2;
        Thu, 16 Mar 2023 08:23:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678955015;
        bh=mTPDV8Jh0qp2PfGmYJWNkKCC+Sl5n+DKud0SPbKyXm0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=V+XDFRIah77sbuTfvxBjRVgQJ8q7N+5Ir7OHSiB8k6my1TWjx301fo37de93BhoSQ
         ys+DyUE96b9BTKCZ5QDopjevmsyKJRdjCZrW8lG0yHaojlhTOqk1P8uaX1qCLqUUJ/
         jKoaAmzecDzcnlb+K1hKVrTG2rWbG1pWiKzzT+s8=
Date:   Thu, 16 Mar 2023 09:23:32 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Alexandru Matei <alexandru.matei@uipath.com>
Cc:     stable@vger.kernel.org, Mihai Petrisor <mihai.petrisor@uipath.com>,
        Viorel Canja <viorel.canja@uipath.com>
Subject: Re: [PATCH 5.10.y v2 2/3] KVM: VMX: Introduce
 vmx_msr_bitmap_l01_changed() helper
Message-ID: <ZBLSBOekc78pTVNw@kroah.com>
References: <20230315090528.4180-1-alexandru.matei@uipath.com>
 <20230315090528.4180-3-alexandru.matei@uipath.com>
 <b8668d09-cfa6-5d94-1e84-f2cdff9b207e@uipath.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b8668d09-cfa6-5d94-1e84-f2cdff9b207e@uipath.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 15, 2023 at 03:41:49PM +0200, Alexandru Matei wrote:
> Hi Greg,
> 
> This patch appeared in the queue without the last Signed-off-by line.

Ah, good catch, my fault, I've fixed it up now in the queue.

thanks,

greg k-h
