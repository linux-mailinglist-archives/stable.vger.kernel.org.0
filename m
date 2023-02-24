Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60A136A2077
	for <lists+stable@lfdr.de>; Fri, 24 Feb 2023 18:27:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229566AbjBXR1N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Feb 2023 12:27:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbjBXR1M (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Feb 2023 12:27:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1553C2C668;
        Fri, 24 Feb 2023 09:27:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CB3AFB81C9C;
        Fri, 24 Feb 2023 17:27:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33121C433D2;
        Fri, 24 Feb 2023 17:27:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677259629;
        bh=XqeMydMl9qKI7IYI6msZA7jxHZlbemp5VBQDQapk78g=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Mw+HI34bvb9LahA0JGdCvSL09NWhGi1vRMuJuAqXJP3bNwMNHhu8ROEjmob6Gd+kY
         QUF/aEeoDD+nJPO9hUPs1GCcHw65VipylNzYU85iTCZKktqBJOpekgXx0kYnKfNKut
         XKsTPNCR8WZNtdOmCCyA6rY94QA7D6jTQs58Lod42yl2FMQYLlbzza1JVrhfaHSEk4
         xOhIXBtjHX0owtIA4RqeQJ3Ms3xHvlPRK2IOVCbGWl7Pb4oeUv5uIyHm4OLYhWZXwD
         qKAkUi8zTDiHTToKJDNhvULisQTiHp6NqYsMgHPj0VnyV0AMsEJPEHUQkxqu7K4MWR
         BUaZLMqJCsLaw==
Date:   Fri, 24 Feb 2023 10:27:06 -0700
From:   Keith Busch <kbusch@kernel.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, Wei Zhang <wzhang@meta.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH 2/2] block: be a bit more careful in checking for NULL
 bdev while polling
Message-ID: <Y/jzas2M7+q4kK52@kbusch-mbp.dhcp.thefacebook.com>
References: <20230224170845.175485-1-axboe@kernel.dk>
 <20230224170845.175485-3-axboe@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230224170845.175485-3-axboe@kernel.dk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Looks good!

Reviewed-by: Keith Busch <kbusch@kernel.org>
