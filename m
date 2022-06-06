Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5059253F1AF
	for <lists+stable@lfdr.de>; Mon,  6 Jun 2022 23:27:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234873AbiFFV1u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jun 2022 17:27:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234763AbiFFV1p (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Jun 2022 17:27:45 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id ED365B863
        for <stable@vger.kernel.org>; Mon,  6 Jun 2022 14:27:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654550862;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=0gHafx1/UEiuRTrmu2J/TCDpx54W1WkTUpOQaQflrmc=;
        b=dkBH3sFenBV97Ba4OxddHdL2J020WXp/1gJOOvj1yDxe1G1ddVBJXOh7EhZkpcf963epwq
        iZZyTOBjw5P6NF70cgNPrOfLznDMHKZtv/Or0xZUSOilDQboozMFQXuKRjHz5eEtOOSQWK
        W0ovXL54l8HDqDbynhJf0udKcOKZzD4=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-340-oIrYucp_M9WDE5STxTnZ7A-1; Mon, 06 Jun 2022 17:27:42 -0400
X-MC-Unique: oIrYucp_M9WDE5STxTnZ7A-1
Received: by mail-il1-f197.google.com with SMTP id w7-20020a056e021c8700b002d3bc8e95cbso12453536ill.3
        for <stable@vger.kernel.org>; Mon, 06 Jun 2022 14:27:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=0gHafx1/UEiuRTrmu2J/TCDpx54W1WkTUpOQaQflrmc=;
        b=y8wtfBvGKjJ2/HiGFsNQCC/YPX2azVlOWJuNt4wu/ktfWFzi8Y71ZdjeVOKb/xqDCx
         6Nsr8EM2C/GtdzzK6EKDEUjzdig3S2TeXITUji8nSPHpKTBBRxlNIziBsMuApVaf0BMZ
         X2QAi5zYJddnOAEFzke+8PGodGS7Ca/DYyJ0KFBQopUxdYy1t8/XQboYah/zBkcsHE7M
         SVLgzAk85pyfB7czvzhfNfM/e3pft1IHA+ky4pv3oy7XC836wHYp6+W2wB568g9OEk4A
         nvot83Xew2+w3C+3+g6QSofe/UG+b0v/jDILxlgkI4lnLxu8xLyp8XUO1mv0fekQkw3f
         NF7A==
X-Gm-Message-State: AOAM530ZVXnNAH0MSV1ib27UrmeHYNVEwwDvkHZOSsN6GIAKDxPeFoAh
        AJTOKNxImf25N39p8SfT3nQmCHHw9mwZceiTsu/aztC2n/nj0hxAVVs77ah0rIQlr50k8GKATmB
        ieNU/kAvDki3Xe/aL
X-Received: by 2002:a6b:b552:0:b0:668:9215:a4a1 with SMTP id e79-20020a6bb552000000b006689215a4a1mr12207349iof.20.1654550861291;
        Mon, 06 Jun 2022 14:27:41 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJygrthUv4dmOMiSXgg0nazpIEw06i7aozoK5SHLCqqaTiiH6rk/o1epUh6iMKjf5nK+vVWocQ==
X-Received: by 2002:a6b:b552:0:b0:668:9215:a4a1 with SMTP id e79-20020a6bb552000000b006689215a4a1mr12207339iof.20.1654550861051;
        Mon, 06 Jun 2022 14:27:41 -0700 (PDT)
Received: from xz-m1.local (cpec09435e3e0ee-cmc09435e3e0ec.cpe.net.cable.rogers.com. [99.241.198.116])
        by smtp.gmail.com with ESMTPSA id a1-20020a056e0208a100b002d53ade2fffsm1449802ilt.85.2022.06.06.14.27.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jun 2022 14:27:40 -0700 (PDT)
Date:   Mon, 6 Jun 2022 17:27:38 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Leonardo Bras <leobras@redhat.com>,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org,
        chang.seok.bae@intel.com, luto@kernel.org, kvm@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH AUTOSEL 5.16 07/28] x86/kvm/fpu: Limit guest
 user_xfeatures to supported bits of XCR0
Message-ID: <Yp5xSi6P3q187+A+@xz-m1.local>
References: <20220301201344.18191-1-sashal@kernel.org>
 <20220301201344.18191-7-sashal@kernel.org>
 <5f2b7b93-d4c9-1d59-14df-6e8b2366ca8a@redhat.com>
 <YppVupW+IWsm7Osr@xz-m1.local>
 <2d9ba70b-ac18-a461-7a57-22df2c0165c6@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <2d9ba70b-ac18-a461-7a57-22df2c0165c6@redhat.com>
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 06, 2022 at 06:18:12PM +0200, Paolo Bonzini wrote:
> > However there seems to be something missing at least to me, on why it'll
> > fail a migration from 5.15 (without this patch) to 5.18 (with this patch).
> > In my test case, user_xfeatures will be 0x7 (FP|SSE|YMM) if without this
> > patch, but 0x0 if with it.
> 
> What CPU model are you using for the VM?

I didn't specify it, assuming it's qemu64 with no extra parameters.

I just tried two other options with: (1) -cpu host, and (2) -cpu Haswell
(the choice of Haswell was really random..), with the same 5.15->5.18
migration scenario, both of them will not trigger the same guest kernel
crash.  Only qemu64 will.

Both hosts have Intel(R) Xeon(R) CPU E5-2630 v4 @ 2.20GHz.

> For example, if the source lacks this patch but the destination has it,
> the source will transmit YMM registers, but the destination will fail to
> set them if they are not available for the selected CPU model.
> 
> See the commit message: "As a bonus, it will also fail if userspace tries to
> set fpu features (with the KVM_SET_XSAVE ioctl) that are not compatible to
> the guest configuration.  Such features will never be returned by
> KVM_GET_XSAVE or KVM_GET_XSAVE2."

IIUC you meant we should have failed KVM_SET_XSAVE when they're not aligned
(probably by failing validate_user_xstate_header when checking against the
user_xfeatures on dest host). But that's probably not my case, because here
KVM_SET_XSAVE succeeded, it's just that the guest gets a double fault after
the precopy migration completes (or for postcopy when the switchover is
done).

Thanks,

-- 
Peter Xu

