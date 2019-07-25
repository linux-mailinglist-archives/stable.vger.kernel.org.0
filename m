Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD2B174DAE
	for <lists+stable@lfdr.de>; Thu, 25 Jul 2019 14:04:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729665AbfGYMEj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Jul 2019 08:04:39 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:37875 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729664AbfGYMEj (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Jul 2019 08:04:39 -0400
Received: by mail-wr1-f66.google.com with SMTP id n9so25417392wrr.4
        for <stable@vger.kernel.org>; Thu, 25 Jul 2019 05:04:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vqKXeZ90q+N46puvA2cVZOXYv8qzvqZWEskJsjgVdVI=;
        b=Q7lzSjt6ip4l4UOTe901ZPwi0lP6AAmuk1XPUujRIFqhTy3RN3+4UrBn1d1JVwzGhW
         THvo2vAFeoRDH5ysy85cM2n+pXpGWbRu2S6zhtBv2d1ffc/gOkZFo601X5CurN5tqYTf
         10EAx/5ucXS5NL5kSy4rf5lyNi7Hy8exIz4jbJq6DtmAzmRggZ5nA1WA6zJNt0IJRORh
         hWlgyAZzGQeLleiUr9qgrHCb3fDeWJEmdTfAM1p8p17n6tmpBlD93phOwNAgLj0fYTYw
         XB8iUYOSBgU+y+IhpWMGG9aRmOEa4AuELgC8oIXENerr/sSdc7bpj+l+9yJShqloeOrt
         Q+WA==
X-Gm-Message-State: APjAAAVqGSSuo2fvTXuspRtVbQaRJ5FvWE82LBgJkMY8XSafyOgmmUyS
        Wu+IkCHMosYEZa41o2jP5m3taT8pQ2M=
X-Google-Smtp-Source: APXvYqxgacEuljaodY+6UYjxTLGKv2jZYcIqdsid+YgNyuPREeL3/l39SCiPJgslt81tpsrt6sQXbw==
X-Received: by 2002:a5d:6a05:: with SMTP id m5mr20540812wru.305.1564056278267;
        Thu, 25 Jul 2019 05:04:38 -0700 (PDT)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id j6sm73793424wrx.46.2019.07.25.05.04.37
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 25 Jul 2019 05:04:37 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     stable@vger.kernel.org
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Subject: [PATCH stable-5.2 0/3] KVM: x86: FPU and nested VMX guest reset fixes
Date:   Thu, 25 Jul 2019 14:04:33 +0200
Message-Id: <20190725120436.5432-1-vkuznets@redhat.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Few patches were recently marked for stable@ but commits are not
backportable as-is and require a few tweaks. Here is 5.2 stable backport.

[PATCHes 2/3 of the series apply as-is, I have them here for completeness]

Jan Kiszka (1):
  KVM: nVMX: Clear pending KVM_REQ_GET_VMCS12_PAGES when leaving nested

Paolo Bonzini (2):
  KVM: nVMX: do not use dangling shadow VMCS after guest reset
  Revert "kvm: x86: Use task structs fpu field for user"

 arch/x86/include/asm/kvm_host.h |  7 ++++---
 arch/x86/kvm/vmx/nested.c       | 10 +++++++++-
 arch/x86/kvm/x86.c              |  4 ++--
 3 files changed, 15 insertions(+), 6 deletions(-)

-- 
2.20.1

