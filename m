Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B74444D1A69
	for <lists+stable@lfdr.de>; Tue,  8 Mar 2022 15:25:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236509AbiCHO0N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Mar 2022 09:26:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237426AbiCHO0M (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Mar 2022 09:26:12 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 308564B866
        for <stable@vger.kernel.org>; Tue,  8 Mar 2022 06:25:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646749515;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kumltRP5xoYTs9zCrvASai08H9k31B5+7rHSh9VugPY=;
        b=aN7D5xEulCZO4qN5dGw0dpoS6gsjmzUc/Uu5dRThH8THuJ03gvhVJ5t2oCX9AT1rFAzJbz
        VIzI9nfc13VS5F1Wb6vXSMroz0Wc+YKQBzpw6p3UYNPuTKF6SehruKMB5Ows1Cn5j2p1U7
        tTqCE2aO47szaAdMARSxBX4OKHTJHro=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-269-e3hj4rfyOcy3gq537nY1-g-1; Tue, 08 Mar 2022 09:25:14 -0500
X-MC-Unique: e3hj4rfyOcy3gq537nY1-g-1
Received: by mail-wm1-f72.google.com with SMTP id f24-20020a1c6a18000000b00388874b17a8so1169091wmc.3
        for <stable@vger.kernel.org>; Tue, 08 Mar 2022 06:25:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=kumltRP5xoYTs9zCrvASai08H9k31B5+7rHSh9VugPY=;
        b=MfNlZk7s3EclZer8JxWcvtb0+BrtwagyEMid7G1WJH1ejIlWu/0+bVcZ4oebRHGBUn
         LiFfdafxMTdBtdPMpwA1QnaQ2nU1pBZ1ZKr2yx6JUTySvvJaBTB3L9vUetYBcWORnsrU
         zQlCM8RRKPQS7KQ1yN3BoPYtP+XDqt/8G+KE7m3VzNK3QYsGWY5Q2frIJo+4512bIORR
         Lm+9QWoZYo40JaYkLCHVyFJurKcmgwYqEMUKQLmHLTLOXkUtAzW7RmGZCEnXnqTynkgk
         MxXEjPYYdueMhrh0TeU5RZLtFv1j485MC1HrXh6jEXS6piAnju3muuJ27mfYMmX9W35R
         WgOA==
X-Gm-Message-State: AOAM53352xT8oQkim1MNR0/M4HAu1hScUs3FIWg4wnfWy/BuuO7TrP3R
        DFiuDHT/YORbo0hnGeCWxQTBpdTLP7wzbEbWVRiBd2Ez7woGZoalJilFglCP5QundhkomZ+JpcW
        ipTK8DZJryO4XBPwO
X-Received: by 2002:a05:6000:154b:b0:1f0:6019:ea3a with SMTP id 11-20020a056000154b00b001f06019ea3amr12330577wry.395.1646749512992;
        Tue, 08 Mar 2022 06:25:12 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxznZCLNljth4M8V08Um5+lfKLr3E/0Oh4tOhNEBRjr9ngJ4D3YE+L+JEPV/yWQExUVOsyeVQ==
X-Received: by 2002:a05:6000:154b:b0:1f0:6019:ea3a with SMTP id 11-20020a056000154b00b001f06019ea3amr12330552wry.395.1646749512782;
        Tue, 08 Mar 2022 06:25:12 -0800 (PST)
Received: from ?IPV6:2003:cb:c708:b000:acda:b420:16aa:6b67? (p200300cbc708b000acdab42016aa6b67.dip0.t-ipconnect.de. [2003:cb:c708:b000:acda:b420:16aa:6b67])
        by smtp.gmail.com with ESMTPSA id v14-20020adfd18e000000b0020373e5319asm244959wrc.103.2022.03.08.06.25.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Mar 2022 06:25:12 -0800 (PST)
Message-ID: <d170ca91-4913-900c-1d2b-b8fc63076124@redhat.com>
Date:   Tue, 8 Mar 2022 15:25:11 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 3/3] KVM: use vcalloc/__vcalloc for very large allocations
Content-Language: en-US
To:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     Michael Ellerman <mpe@ellerman.id.au>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>,
        Christoph Lameter <cl@linux.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@kernel.org>,
        Vladimir Davydov <vdavydov.dev@gmail.com>, linux-mm@kvack.org,
        cgroups@vger.kernel.org, stable@vger.kernel.org
References: <20220308105918.615575-1-pbonzini@redhat.com>
 <20220308105918.615575-4-pbonzini@redhat.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <20220308105918.615575-4-pbonzini@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 08.03.22 11:59, Paolo Bonzini wrote:
> Allocations whose size is related to the memslot size can be arbitrarily
> large.  Do not use kvzalloc/kvcalloc, as those are limited to "not crazy"
> sizes that fit in 32 bits.  Now that it is available, they can use either
> vcalloc or __vcalloc, the latter if accounting is required.
> 
> Cc: stable@vger.kernel.org
> Cc: kvm@vger.kernel.org
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

Fixes: 7661809d493b ("mm: don't allow oversized kvmalloc() calls")

?

Reviewed-by: David Hildenbrand <david@redhat.com>


-- 
Thanks,

David / dhildenb

