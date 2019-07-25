Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E631274C1A
	for <lists+stable@lfdr.de>; Thu, 25 Jul 2019 12:47:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728436AbfGYKqt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Jul 2019 06:46:49 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:36217 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728288AbfGYKqt (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Jul 2019 06:46:49 -0400
Received: by mail-wr1-f68.google.com with SMTP id n4so50313610wrs.3
        for <stable@vger.kernel.org>; Thu, 25 Jul 2019 03:46:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pjvXzHuYUakR2/Ani3ARG2fLWxvZAXWrrCuKN/oKrQA=;
        b=lyzkA2KvQsKEBQyFvoWN6HPN2EnoNeffM8YWsTdIJljPzv9/d09eBmPA+D1Rne3Z1m
         MvrzhobuGuRTr4+eOkdW8EsW2stmeX1U5rcBf6YSbH7s08mC0vtEuabQipoWNkyH9VcF
         4EOmwhsFvOu4NyWYrHlYJmtwAzS07Xw5E4MaJ+Uk5Fo+5sdpxLk+h7FCl8oJmxOU/G45
         rSe/TeeX/HXx/a4ON+WhGaS9tNpcNYlJrv/gO7WXoR3q+cra2Nx51ko+T87GfYFuW1+J
         VEE+MijjqRkRO8pcIuZnY4ztg2YYYR/kIE871QIWqouOE5n4Ckw8nbPwprOtndLzXqMU
         s6EQ==
X-Gm-Message-State: APjAAAV5/bt+mhIFUKHemGVdiyXt03VJhBf0g7t+759dopLctzAJGF9K
        m9Sn/QgXKXNwN80/VjKOsU3qxV+Pfek=
X-Google-Smtp-Source: APXvYqwoFxodO1E/5vAA3SDxtHGf23l+eqoIo+8ZfDDxQgcNNEAScxQXjmpGb4BGzRNs9hlgbhxRCQ==
X-Received: by 2002:a5d:65c5:: with SMTP id e5mr46038769wrw.266.1564051607733;
        Thu, 25 Jul 2019 03:46:47 -0700 (PDT)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id f204sm72042696wme.18.2019.07.25.03.46.46
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 25 Jul 2019 03:46:47 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     stable@vger.kernel.org
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Subject: [PATCH stable-4.19 0/2] KVM: nVMX: guest reset fixes
Date:   Thu, 25 Jul 2019 12:46:43 +0200
Message-Id: <20190725104645.30642-1-vkuznets@redhat.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Few patches were recently marked for stable@ but commits are not
backportable as-is and require a few tweaks. Here is 4.19 stable backport.

Jan Kiszka (1):
  KVM: nVMX: Clear pending KVM_REQ_GET_VMCS12_PAGES when leaving nested

Paolo Bonzini (1):
  KVM: nVMX: do not use dangling shadow VMCS after guest reset

 arch/x86/kvm/vmx.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

-- 
2.20.1

