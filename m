Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB21D53166C
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 22:51:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230261AbiEWT2Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 15:28:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230295AbiEWT14 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 15:27:56 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6EF07A33B1
        for <stable@vger.kernel.org>; Mon, 23 May 2022 12:07:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653332859;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cyh9GNwkSeiWX8VVWJet6cmrStrv1Y1BhHYKMAKCy08=;
        b=CQDrERvRStr18UES6TqKLDlpTpcY1akZjELqld3n8HEVme5h4wJRrVyg2l4lRG+SKBQUeI
        lI8lxEk8Zxey92g3Zgi1cRXX28tVlYQ9IXXrg4BVHQrx8F1vir7Wik30KVz3loDRfsOqZS
        lzqql0vGQFhC91Tp3MzyBUd13vOWVM8=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-91-DTHuyVKtMrCt--Nfyuy6tA-1; Mon, 23 May 2022 15:07:34 -0400
X-MC-Unique: DTHuyVKtMrCt--Nfyuy6tA-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 39AC11C3E985;
        Mon, 23 May 2022 19:07:33 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4033F492C14;
        Mon, 23 May 2022 19:07:32 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     Ashish Kalra <Ashish.Kalra@amd.com>
Cc:     pbonzini@redhat.com, seanjc@google.com, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, joro@8bytes.org,
        Thomas.Lendacky@amd.com, bp@alien8.de, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        theflow@google.com, rientjes@google.com, pgonda@google.com,
        john.allen@amd.com, stable@vger.kernel.org, michael.roth@amd.com
Subject: Re: [PATCH v2] KVM: SVM: Use kzalloc for sev ioctl interfaces to prevent kernel memory leak.
Date:   Mon, 23 May 2022 15:07:30 -0400
Message-Id: <20220523190730.148395-1-pbonzini@redhat.com>
In-Reply-To: <20220516154310.3685678-1-Ashish.Kalra@amd.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Queued, thanks.

Paolo


