Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC8A250A096
	for <lists+stable@lfdr.de>; Thu, 21 Apr 2022 15:20:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231544AbiDUNXN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Apr 2022 09:23:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231631AbiDUNXI (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 Apr 2022 09:23:08 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5C77FBC81
        for <stable@vger.kernel.org>; Thu, 21 Apr 2022 06:20:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650547218;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to; bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
        b=T412h2q95lFL6ExDX3jWWWKtvQbpsOLIkbSRUrd3wBulSgM+YqgwKZxDo7AIpN/1MwdXji
        dkPQoHdHi/8u1ZGx8W7Pe16cY/vd2NKHzfbT/9pxp8oWCgmEcA5vL3y0uuYjTseXcmtEkY
        p9EBIJPrKj5QftrhLnIPp52uPNFxGxs=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-47-K-jwSEu2P5CL7AVo4yj31g-1; Thu, 21 Apr 2022 09:20:17 -0400
X-MC-Unique: K-jwSEu2P5CL7AVo4yj31g-1
Received: by mail-pl1-f197.google.com with SMTP id i10-20020a170902e48a00b00153f493fa9aso2523788ple.17
        for <stable@vger.kernel.org>; Thu, 21 Apr 2022 06:20:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:in-reply-to;
        bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
        b=XwmeN7aVxfOJQokCUp1gkQ7VzDNKxCZZS9qg3zzjOJdzvbcAR2NDNZbjZfHtLP5P0R
         1RjZDZxWBpGIkTnMZ5NQHn/1ueeL23exOnFcAEJMjFLvvg7VybmnMWyenh+MgUfHqwvl
         WsG4cuuZcCzGjwOt4eL69QsCXFbIyCLH4p+SPcLF9kaNsvbvZOFbvn1WbDQNofVI8DyU
         0e2cII1+ew9rE0co/l2D+G2IDrqrZyyv1E+OHKPJHYIeRugakfpVKJh4FxFQhTDqVRSR
         iWZ2YfJlzg84LlQNfu3P6e7J3MoScyiNrvq4Rpy1S6mGnv/kUfS4GUwiNq/BEoPVrECn
         8yPA==
X-Gm-Message-State: AOAM531PpZE9fb1d3VyVLekdXSYd2nRHejvZWhb4+Pj7rwbXI0jVvDgq
        ehSvdMd82SXYU9OgIzOJuempq7iCiL1Zf+/vVBqsUNVxsPLTkyNuLsnFkOY7Lar63cEPdWutmPI
        VCnxqE6kd4Ns8H7/c
X-Received: by 2002:a05:6a00:ccf:b0:50a:db82:4ae5 with SMTP id b15-20020a056a000ccf00b0050adb824ae5mr3581854pfv.59.1650547212328;
        Thu, 21 Apr 2022 06:20:12 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyEg/XKr6Ui9gwh2MQYBfHjjkLlJhmxTVmRmjaeYiITKwKssa5krUtFdDxn4eFPTWFfCNVNig==
X-Received: by 2002:a05:6a00:ccf:b0:50a:db82:4ae5 with SMTP id b15-20020a056a000ccf00b0050adb824ae5mr3581819pfv.59.1650547211962;
        Thu, 21 Apr 2022 06:20:11 -0700 (PDT)
Received: from localhost.localdomain ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id lw3-20020a17090b180300b001cd4989fecesm2984649pjb.26.2022.04.21.06.20.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Apr 2022 06:20:11 -0700 (PDT)
Date:   Thu, 21 Apr 2022 21:20:00 +0800
From:   Tao Liu <ltao@redhat.com>
To:     joro@8bytes.org
Cc:     cfir@google.com, dan.j.williams@intel.com,
        dave.hansen@linux.intel.com, ebiederm@xmission.com,
        erdemaktas@google.com, hpa@zytor.com, jgross@suse.com,
        jroedel@suse.de, jslaby@suse.cz, keescook@chromium.org,
        kexec@lists.infradead.org, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org,
        luto@kernel.org, martin.b.radev@gmail.com, mhiramat@kernel.org,
        mstunes@vmware.com, nivedita@alum.mit.edu, peterz@infradead.org,
        rientjes@google.com, seanjc@google.com, stable@vger.kernel.org,
        thomas.lendacky@amd.com, virtualization@lists.linux-foundation.org,
        x86@kernel.org
Subject: Re: [PATCH 01/12] kexec: Allow architecture code to opt-out at
 runtime
Message-ID: <YmFaAFcQPhSWNEFz@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210721142015.1401-2-joro@8bytes.org>
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

