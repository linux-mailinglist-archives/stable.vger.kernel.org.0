Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D20E76E7585
	for <lists+stable@lfdr.de>; Wed, 19 Apr 2023 10:41:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232385AbjDSIlo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Apr 2023 04:41:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232177AbjDSIln (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Apr 2023 04:41:43 -0400
Received: from out-50.mta0.migadu.com (out-50.mta0.migadu.com [91.218.175.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA71F72A4
        for <stable@vger.kernel.org>; Wed, 19 Apr 2023 01:41:41 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1681893698;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nAL5cKdJD52GbjJBtt/2QV2gYrAcEMuOsmINS4xoZFk=;
        b=tufRf45nYih6R+sCvytwBxxJDbWXBzl09Z6qUfbWHU6jo5tOmdd3XGtAye/16f6RSZu9DK
        w95pIwyTHGG8WlML2hQcAP6VMwu2awX7jqvrEr7IFkVX2RlGfL1GueG5p2QVFZ8r3HqcBb
        /QaTAmcTIQBpVkyFDYCRRAeDdqmu3ak=
From:   Oliver Upton <oliver.upton@linux.dev>
To:     linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev, Marc Zyngier <maz@kernel.org>
Cc:     Oliver Upton <oliver.upton@linux.dev>,
        Mostafa Saleh <smostafa@google.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        stable@vger.kernel.org, James Morse <james.morse@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Will Deacon <will@kernel.org>,
        Quentin Perret <qperret@google.com>
Subject: Re: [PATCH v2] KVM: arm64: Make vcpu flag updates non-preemptible
Date:   Wed, 19 Apr 2023 08:41:26 +0000
Message-ID: <168189366436.3163688.14802526283160116596.b4-ty@linux.dev>
In-Reply-To: <20230418125737.2327972-1-maz@kernel.org>
References: <20230418125737.2327972-1-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 18 Apr 2023 13:57:37 +0100, Marc Zyngier wrote:
> Per-vcpu flags are updated using a non-atomic RMW operation.
> Which means it is possible to get preempted between the read and
> write operations.
> 
> Another interesting thing to note is that preemption also updates
> flags, as we have some flag manipulation in both the load and put
> operations.
> 
> [...]

Applied to kvmarm/fixes, thanks!

[1/1] KVM: arm64: Make vcpu flag updates non-preemptible
      https://git.kernel.org/kvmarm/kvmarm/c/35dcb3ac663a

--
Best,
Oliver
