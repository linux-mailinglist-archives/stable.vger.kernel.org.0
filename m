Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FDD830CC92
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 21:01:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240309AbhBBUAw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 15:00:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:38944 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232858AbhBBNsm (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 08:48:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 17EFC64F9D;
        Tue,  2 Feb 2021 13:42:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612273330;
        bh=q8B5u5WTtJqSQ/d9Dmg9CZqvVrKo5KYLLi5W/3UP6rc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e4Q9SAC9Y/m+DVUWRGr5IO79DNrmj+3nGxnmrOw8PtVLa6Qrfgspz6zec40CKNeSP
         4beF4PQWkXGvS1+KzlmD+UrZzRff/GaiiL4qRGIKfPgr06tsFKQPZNlsLb4woHBDdO
         6dWPrUoAaG5QXyXMoH8kgS1K8QTb9AbG3DlT1ueI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Quentin Perret <qperret@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.10 066/142] KVM: Documentation: Fix spec for KVM_CAP_ENABLE_CAP_VM
Date:   Tue,  2 Feb 2021 14:37:09 +0100
Message-Id: <20210202133000.449940320@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210202132957.692094111@linuxfoundation.org>
References: <20210202132957.692094111@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Quentin Perret <qperret@google.com>

commit a10f373ad3c760dd40b41e2f69a800ee7b8da15e upstream.

The documentation classifies KVM_ENABLE_CAP with KVM_CAP_ENABLE_CAP_VM
as a vcpu ioctl, which is incorrect. Fix it by specifying it as a VM
ioctl.

Fixes: e5d83c74a580 ("kvm: make KVM_CAP_ENABLE_CAP_VM architecture agnostic")
Signed-off-by: Quentin Perret <qperret@google.com>
Message-Id: <20210108165349.747359-1-qperret@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 Documentation/virt/kvm/api.rst |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -1319,7 +1319,7 @@ documentation when it pops into existenc
 
 :Capability: KVM_CAP_ENABLE_CAP_VM
 :Architectures: all
-:Type: vcpu ioctl
+:Type: vm ioctl
 :Parameters: struct kvm_enable_cap (in)
 :Returns: 0 on success; -1 on error
 


