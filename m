Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBF16508B24
	for <lists+stable@lfdr.de>; Wed, 20 Apr 2022 16:50:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354644AbiDTOw6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Apr 2022 10:52:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379782AbiDTOwr (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Apr 2022 10:52:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB967B1F3
        for <stable@vger.kernel.org>; Wed, 20 Apr 2022 07:50:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 75AEEB81F94
        for <stable@vger.kernel.org>; Wed, 20 Apr 2022 14:49:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EBE3C385A0;
        Wed, 20 Apr 2022 14:49:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650466198;
        bh=7yUjL4osBCzwyo+o0xsPqX0kxWSIuC7pDXj7izW6w7g=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Oo+KCXrGEZVq/dhELY0aGrJanCdyLq43rPp9e3mAB5MP057HF0ceFQBmwmmfstZxH
         XIcOmXMlBEZI3J7KkpEekWuGAFvO0MQVb2UBtVHERUpscxZsecO2Hs4YbBarfij3HM
         9Zk9wJBNQA9KxCQpl7cqV54oGLchudyTs4or+PFTNATaBVuiEAPKk5M+xj5/nMj6nr
         kKQFP98tjF8zy1JxRJxRZ7LmiiNpiqT7GwkS9FgIEYNwM7nCRy84FKDXfxAExR7fcO
         70v+xZiSA1sgHfjftjTF9B6g5BTy1OQ0VxpvuNUY0ifMLlb0dGbOXBQ1kY13ey+TkQ
         H7BloCUCYYqtw==
Date:   Wed, 20 Apr 2022 10:49:56 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Georgi Djakov <quic_c_gdjako@quicinc.com>
Cc:     stable@vger.kernel.org, rppt@linux.ibm.com,
        anshuman.khandual@arm.com, david@redhat.com, will@kernel.org,
        catalin.marinas@arm.com, hch@lst.de, akpm@linux-foundation.org,
        surenb@google.com, quic_sudaraja@quicinc.com, djakov@kernel.org
Subject: Re: [PATCH 5.15 2/2] arm64/mm: drop HAVE_ARCH_PFN_VALID
Message-ID: <YmAdlNslaGbSKUj4@sashalap>
References: <20220420124341.14982-1-quic_c_gdjako@quicinc.com>
 <20220420124341.14982-2-quic_c_gdjako@quicinc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20220420124341.14982-2-quic_c_gdjako@quicinc.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 20, 2022 at 05:43:41AM -0700, Georgi Djakov wrote:
>From: Anshuman Khandual <anshuman.khandual@arm.com>
>
>[ Upstream commit 3de360c3fdb34fbdbaf6da3af94367d3fded95d3 ]
>
>CONFIG_SPARSEMEM_VMEMMAP is now the only available memory model on arm64
>platforms and free_unused_memmap() would just return without creating any
>holes in the memmap mapping.  There is no need for any special handling in
>pfn_valid() and HAVE_ARCH_PFN_VALID can just be dropped.  This also moves
>the pfn upper bits sanity check into generic pfn_valid().

It's not clear why we need this patch in stable.

-- 
Thanks,
Sasha
