Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AE855AB619
	for <lists+stable@lfdr.de>; Fri,  2 Sep 2022 17:59:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236755AbiIBP7h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 11:59:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236498AbiIBP7S (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 11:59:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37AECE01B;
        Fri,  2 Sep 2022 08:53:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C884762013;
        Fri,  2 Sep 2022 15:53:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5D8BC433C1;
        Fri,  2 Sep 2022 15:53:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662134036;
        bh=QCgsK1Pg/IUXYOh9bTRo6nAIJJyhIyOeOefYBPTtfj0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=spev8F1cnhg+nd67NQ7dvkwlZQxYdDSFsxF+E3LzKpHq02IBBKUKd9xNp7C58eXCj
         fkwtmIPqCb1iubyS38gqS72tgD1/NIdLHL+CHlEKmG+P6YOWiBR0G8qCvwjqiqC3LL
         FCzEOa5b5C/1rQYzvEUiGXlS0Fd7X6lH6G93/rSeO3CSonys6ARvKghX2TBzKgvLp5
         Hi8rn6Q/NsgBQtpk2bQJJDwr4pJZFq4+QTszQ4NFBGe3LmeckcOWysV6X65hmOz81Z
         Jzkp5ht7DUuM1L5sW9LnzPSEQbSA8YlfhMpzB+cdZ+oIY1A9tMN/BH7Kx8BKK07xHs
         2505usmYmntqA==
Date:   Fri, 2 Sep 2022 18:53:51 +0300
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Reinette Chatre <reinette.chatre@intel.com>
Cc:     linux-sgx@vger.kernel.org,
        Haitao Huang <haitao.huang@linux.intel.com>,
        Vijay Dhanraj <vijay.dhanraj@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Paul Menzel <pmenzel@molgen.mpg.de>, stable@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" 
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 2/6] x86/sgx: Do not consider unsanitized pages an
 error
Message-ID: <YxInD1m7rEnQ/yxW@kernel.org>
References: <20220831173829.126661-1-jarkko@kernel.org>
 <20220831173829.126661-3-jarkko@kernel.org>
 <24906e57-461f-6c94-9e78-0d8507df01bb@intel.com>
 <YxEp8Ji+ukLBoNE+@kernel.org>
 <84b8eb06-7b77-675f-5bc8-292fe27dd2f5@intel.com>
 <YxFGykqMb+TD4L4l@kernel.org>
 <YxIEm4uHVvUY/rv6@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YxIEm4uHVvUY/rv6@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Sep 02, 2022 at 04:26:51PM +0300, Jarkko Sakkinen wrote:
> +	if (ret)
> +		pr_err("%ld unsanitized pages\n", left_dirty);

Yeah, I know, should be 'left_dirty'. I just quickly drafted
the patch for the email.

BR, Jarkko
