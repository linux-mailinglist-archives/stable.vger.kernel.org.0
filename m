Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77A5C115142
	for <lists+stable@lfdr.de>; Fri,  6 Dec 2019 14:45:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726313AbfLFNpa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Dec 2019 08:45:30 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:55573 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726213AbfLFNpa (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 Dec 2019 08:45:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575639929;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=AxChkYm0yBQdYCSo9K5fS2Y6ct4oJJSVzt3QR9uwmtY=;
        b=K724XoU700/1AIR8XOWIU1DAPma+R3a5w5B3WLgIBP+bhJqYTa2/s1u01foINIwS6EkoHL
        DmJqTgUPcTt07Zp91ozuZftEyApAuKFpl4SJXsrhhkmLHdABhKbOjEQ/bzW6tabQ4uRo2U
        gAn2GZdrSJpJV4OoxzBXmBa5Fl3BqLk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-312-I2YEdcGCO4uHrjah08uYYg-1; Fri, 06 Dec 2019 08:45:23 -0500
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A78F78017DF;
        Fri,  6 Dec 2019 13:45:21 +0000 (UTC)
Received: from thuth.com (ovpn-116-205.ams2.redhat.com [10.36.116.205])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5E2006B8F0;
        Fri,  6 Dec 2019 13:45:14 +0000 (UTC)
From:   Thomas Huth <thuth@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel@vger.kernel.org
Cc:     rkrcmar@redhat.com, radimkrcmar@gmail.com, drjones@redhat.com,
        stable@vger.kernel.org, sean.j.christopherson@intel.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org
Subject: [PATCH] KVM: Radim is no longer available as KVM maintainer
Date:   Fri,  6 Dec 2019 14:45:11 +0100
Message-Id: <20191206134511.20036-1-thuth@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-MC-Unique: I2YEdcGCO4uHrjah08uYYg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Radim's mail address @redhat.com is not valid anymore, so we should
remove this line from the MAINTAINERS file to avoid that people send
mails to this address in vain.

Thank you very much for all your work on KVM during the past years,
Radim!

Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 MAINTAINERS | 2 --
 1 file changed, 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 067cae5bde23..54cf6e242e54 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -9043,7 +9043,6 @@ F:=09include/linux/umh.h
=20
 KERNEL VIRTUAL MACHINE (KVM)
 M:=09Paolo Bonzini <pbonzini@redhat.com>
-M:=09Radim Kr=C4=8Dm=C3=A1=C5=99 <rkrcmar@redhat.com>
 L:=09kvm@vger.kernel.org
 W:=09http://www.linux-kvm.org
 T:=09git git://git.kernel.org/pub/scm/virt/kvm/kvm.git
@@ -9115,7 +9114,6 @@ F:=09tools/testing/selftests/kvm/*/s390x/
=20
 KERNEL VIRTUAL MACHINE FOR X86 (KVM/x86)
 M:=09Paolo Bonzini <pbonzini@redhat.com>
-M:=09Radim Kr=C4=8Dm=C3=A1=C5=99 <rkrcmar@redhat.com>
 R:=09Sean Christopherson <sean.j.christopherson@intel.com>
 R:=09Vitaly Kuznetsov <vkuznets@redhat.com>
 R:=09Wanpeng Li <wanpengli@tencent.com>
--=20
2.18.1

