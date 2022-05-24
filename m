Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 083BE532847
	for <lists+stable@lfdr.de>; Tue, 24 May 2022 12:54:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236413AbiEXKyJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 May 2022 06:54:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236409AbiEXKyG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 May 2022 06:54:06 -0400
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 214A16D4DE;
        Tue, 24 May 2022 03:54:06 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4L6rfh119Lz4yT3;
        Tue, 24 May 2022 20:54:04 +1000 (AEST)
From:   Michael Ellerman <patch-notifications@ellerman.id.au>
To:     akpm@linux-foundation.org, bharata@linux.ibm.com,
        linuxram@us.ibm.com, Felix.Kuehling@amd.com, mpe@ellerman.id.au,
        paulus@samba.org, benh@kernel.crashing.org,
        maciej.szmigiero@oracle.com, maz@kernel.org, david@redhat.com,
        Xiaomeng Tong <xiam0nd.tong@gmail.com>,
        liam.howlett@oracle.com, apopple@nvidia.com
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
In-Reply-To: <20220414062103.8153-1-xiam0nd.tong@gmail.com>
References: <20220414062103.8153-1-xiam0nd.tong@gmail.com>
Subject: Re: [RESEND][PATCH] KVM: PPC: Book3S HV: fix incorrect NULL check on list iterator
Message-Id: <165338950780.1711920.5897036006589907982.b4-ty@ellerman.id.au>
Date:   Tue, 24 May 2022 20:51:47 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 14 Apr 2022 14:21:03 +0800, Xiaomeng Tong wrote:
> The bug is here:
> 	if (!p)
>                 return ret;
> 
> The list iterator value 'p' will *always* be set and non-NULL by
> list_for_each_entry(), so it is incorrect to assume that the iterator
> value will be NULL if the list is empty or no element is found.
> 
> [...]

Applied to powerpc/topic/ppc-kvm.

[1/1] KVM: PPC: Book3S HV: fix incorrect NULL check on list iterator
      https://git.kernel.org/powerpc/c/300981abddcb13f8f06ad58f52358b53a8096775

cheers
