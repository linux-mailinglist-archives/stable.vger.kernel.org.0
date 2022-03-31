Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4C1C4ED312
	for <lists+stable@lfdr.de>; Thu, 31 Mar 2022 06:54:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229682AbiCaEp5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 31 Mar 2022 00:45:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229684AbiCaEpx (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 31 Mar 2022 00:45:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4AA866CA6;
        Wed, 30 Mar 2022 21:44:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 04903614EE;
        Thu, 31 Mar 2022 04:44:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C39F0C340EE;
        Thu, 31 Mar 2022 04:44:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1648701842;
        bh=anX+FbCJ55E/GPJ6YynFAUx9WHPtSUGYdYpZlDtNxCA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=0lvEQuLaSEvb++6QMvm/LaczjeL3RTOHxGHyD8ilXm81orWVHMQpttptPDT2UtWn9
         lh5f5N2QHe2h/RM30tjSDpq+jVlpnZ4ESMOzODezAL/N3ZHRV+7IZLdZ/4BE9TU0Cj
         nAtNQpYGCsVdN6MD+4Xz1vci9CIqYOiigvf12GeQ=
Date:   Thu, 31 Mar 2022 06:43:58 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "wangyanan (Y)" <wangyanan55@huawei.com>
Cc:     Like Xu <like.xu.linux@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>,
        Eric Hankland <ehankland@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] KVM: x86/pmu: Update AMD PMC smaple period to fix guest
 NMI-watchdog
Message-ID: <YkUxjlv48jAF3gZ5@kroah.com>
References: <20220329134632.6064-1-likexu@tencent.com>
 <516a87a9-71d3-a4a7-83bf-1d8e36745e61@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <516a87a9-71d3-a4a7-83bf-1d8e36745e61@huawei.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 31, 2022 at 11:51:55AM +0800, wangyanan (Y) wrote:
> helped to Cc stable@ list...


<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
