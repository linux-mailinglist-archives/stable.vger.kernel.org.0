Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A8CE4B3859
	for <lists+stable@lfdr.de>; Sat, 12 Feb 2022 23:20:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231158AbiBLWUr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 12 Feb 2022 17:20:47 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:38712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230142AbiBLWUr (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 12 Feb 2022 17:20:47 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 530D460A82;
        Sat, 12 Feb 2022 14:20:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 16C6AB80884;
        Sat, 12 Feb 2022 22:20:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0796C340E7;
        Sat, 12 Feb 2022 22:20:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644704439;
        bh=F1YLPckivmEhBO2oiSxCtRmozC2yZVGz2536YwqxQ04=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rscvcH2lIKlArWYx4p2Vz560lptLce9KzRL8lG/ZXmp/BVIH4JQUACGG+RA8jqOHm
         OD0ImzMWykMtz/j++BXSd2QJqhmouCsD/0oUOKnAxbRTU7eafvXvvdjPsG/HWq56nJ
         8diyVCeNBSwmkRdVsAQPEFVU55/9+LyxgBkWypuxIOxMFrABIek4oN/vi6eWVx50d9
         wxpzdxPR4hfG+/CgHhY4ptgRW1WKwm5FKHNLjmi4tpNT3Q/D5rsg0iPNvu9vt8AGsC
         oOJGMwoENeutavXYNqX5K7y5/0rxGh/CKTC1dRkCcYC25I6hwYJYsk82PMvDEQSmqZ
         NAfgWTUtIjEgQ==
Date:   Sat, 12 Feb 2022 17:20:38 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Hou Wenlong <houwenlong93@linux.alibaba.com>,
        Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org
Subject: Re: [PATCH MANUALSEL 5.16 1/8] KVM: eventfd: Fix false positive RCU
 usage warning
Message-ID: <YggytmXTEsXqYw5C@sashalap>
References: <20220209185635.48730-1-sashal@kernel.org>
 <6f3d4ed7-f3c1-7c06-d5cf-1bd824731e43@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <6f3d4ed7-f3c1-7c06-d5cf-1bd824731e43@redhat.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 10, 2022 at 05:41:03PM +0100, Paolo Bonzini wrote:
>On 2/9/22 19:56, Sasha Levin wrote:
>>From: Hou Wenlong <houwenlong93@linux.alibaba.com>
>>
>>[ Upstream commit 6a0c61703e3a5d67845a4b275e1d9d7bc1b5aad7 ]
>
>Acked-by: Paolo Bonzini <pbonzini@redhat.com>

I've queued up all the ones you've acked, thanks!

-- 
Thanks,
Sasha
