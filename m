Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3A686ECC5F
	for <lists+stable@lfdr.de>; Mon, 24 Apr 2023 14:52:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231666AbjDXMwh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Apr 2023 08:52:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231299AbjDXMwd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Apr 2023 08:52:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17C2910E0
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 05:52:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 60B086155C
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 12:51:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EDF9C433D2;
        Mon, 24 Apr 2023 12:51:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1682340717;
        bh=uRY5EwAko+3T5DCIhVrg/QctyFmLU/K5l5Skpv/9n/A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QcaOXqly9sfaiFRdP2cQLbKm0TV85wTs/xj36uW6qO2NIq49z0SYEf5jwjbIgC6Ru
         7S7TOeiwjC1xGN6QDk0KNxguh2L0pUBS2yNXl8cJ6iyA3taeOKR04cLRAx1jlMeKCI
         /hbkRKJecsiliFgg1uK4BNZIibt6XSNs4w2SjDNE=
Date:   Mon, 24 Apr 2023 14:51:55 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Alexandre Ghiti <alexghiti@rivosinc.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 5.15.108 0/3] Fixes for dtb mapping
Message-ID: <2023042403-renewal-ripcord-736b@gregkh>
References: <20230424115618.185321-1-alexghiti@rivosinc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230424115618.185321-1-alexghiti@rivosinc.com>
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 24, 2023 at 01:56:15PM +0200, Alexandre Ghiti wrote:
> We used to map the dtb differently between early_pg_dir and
> swapper_pg_dir which caused issues when we referenced addresses from
> the early mapping with swapper_pg_dir (reserved_mem): move the dtb mapping
> to the fixmap region in patch 1, which allows to simplify dtb handling in
> patch 2.
> 
> base-commit-tag: v5.15.108

Please look at the archives of the stable kernel mailing list for
examples of how to do this.

Also, what about 6.1.y and 6.2.y?  You can't have someone upgrade from
an older kernel to a new one and have a regression, right?

Please fix this up and send patches for all relevant trees.

thanks,

greg k-h
