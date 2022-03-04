Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F21174CDE1C
	for <lists+stable@lfdr.de>; Fri,  4 Mar 2022 21:25:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231189AbiCDUJ5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Mar 2022 15:09:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231542AbiCDUIR (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Mar 2022 15:08:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59C2C2013D4;
        Fri,  4 Mar 2022 12:03:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 57B4E619AC;
        Fri,  4 Mar 2022 19:26:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7154CC340E9;
        Fri,  4 Mar 2022 19:26:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646421972;
        bh=KBHS9SF7np289y1DxinrbwVOMSzyBKoC+Dj197ZBpEE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Frd5Z34uDjWwE2oz30FMni60csLVWU/WMG1NBlfjbNSYqu2iQSa8W+NZkYsymc6xr
         7LTNC9P+0q3GEYAHueBW+cv0b5bvTRHQkCLS/7zEXmKOkn/f7MMe5vQ83xvYUxly11
         F/jL1LtjtikPYJa49VjY3sKGDGIhnRTu4aiWbBxYA4XTuHWXO60EifFjUlmKN++kJP
         uAQr08lBhqJ9QUpxDuOpHH8JH9JIy09b6hMzhJotjc/bre2ZSZ1HuFi2tQAKYgeoRw
         tc4UrLWWS0hbNFnRX4J2M8Y2pCHoEnFFFBOfgHhJ/VZKdenvih5MbYpgG5TOmzFfH9
         0YQ/DqSkysFKA==
Date:   Fri, 4 Mar 2022 11:26:10 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Jarkko Sakkinen <jarkko@kernel.org>
Cc:     David Howells <dhowells@redhat.com>, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-integrity@vger.kernel.org,
        Stefan Berger <stefanb@linux.ibm.com>,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Tianjia Zhang <tianjia.zhang@linux.alibaba.com>,
        Vitaly Chikunov <vt@altlinux.org>,
        Mimi Zohar <zohar@linux.ibm.com>, stable@vger.kernel.org
Subject: Re: [PATCH 1/2] KEYS: asymmetric: enforce that sig algo matches key
 algo
Message-ID: <YiJn0lJxoUMUJ6wP@sol.localdomain>
References: <20220201003414.55380-1-ebiggers@kernel.org>
 <20220201003414.55380-2-ebiggers@kernel.org>
 <YhLuOeIKLwlucpKv@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YhLuOeIKLwlucpKv@kernel.org>
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 21, 2022 at 02:43:21AM +0100, Jarkko Sakkinen wrote:
> 
> Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
> 
> David, do you want to pick this?
> 

No response from David, so I think you need to take these.

- Eric
