Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 639A0654996
	for <lists+stable@lfdr.de>; Fri, 23 Dec 2022 01:10:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235678AbiLWAKf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Dec 2022 19:10:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235227AbiLWAKZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Dec 2022 19:10:25 -0500
Received: from out3-smtp.messagingengine.com (out3-smtp.messagingengine.com [66.111.4.27])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D41B22BF8;
        Thu, 22 Dec 2022 16:10:22 -0800 (PST)
Received: from compute6.internal (compute6.nyi.internal [10.202.2.47])
        by mailout.nyi.internal (Postfix) with ESMTP id 0E2B15C0110;
        Thu, 22 Dec 2022 19:10:22 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Thu, 22 Dec 2022 19:10:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=tyhicks.com; h=
        cc:cc:content-transfer-encoding:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm1; t=1671754222; x=1671840622; bh=on
        htEckhuX8csdtNozlcaBjqdIEEh4L7+8wYGdwUQtU=; b=OL6SwrpwQEbQ99nqQt
        sf7U9qkrJc8k9sPOzJaV7bfIxFwfmAE8tn5s8gIGc60Df7D068SXzBcWe5NBc/Gi
        xo7kv0XBCp1p3zyqvEGsl6AcKf3rmmvFeuXIReMajv9Y5+24gyhw+d8zJJN8b9BX
        fSqJC+By6q3F/1E7TICQKcOt3KMSpLbxBED1zDCrWzf99nOTYMlCP/zFKUSmFWF6
        1NWcflTBXYN6ruNqOJxeOafjf/LcNp9Haso0AeJIr34oqx+d/oZCZAwEqMGuc53E
        5RkCqDkoceOvRrvcJMN+qCxSq4PlvaPf5/sZHjCcgTmPuoTn0cik+cuVexQozWn4
        x/EA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm2; t=1671754222; x=1671840622; bh=onhtEckhuX8cs
        dtNozlcaBjqdIEEh4L7+8wYGdwUQtU=; b=LYLT8OqlbPm6qYtjmIt58QE+u9f59
        P8ZL7Z9e3ozdIR+ZfcqpSfawmNTQwEOOMSN1LSaX9VQUqjumQ46pi/IvrKq2SvEK
        SW4rRY8fP+9pvm085lWNpDlsEY1CPTOjX4aBqvDRlUmAOjz0GMdKRfFEg3DrD2pN
        93arsnKNS/LZ4cjGr0xI3wTt/Uxfk9MVmlicyTZAU8FPo0ENO7ObnVqWbUIp84LX
        sW+Xkgz+fNWMbg/qauQoodlVHvley6McZ4p4K3GqUdD3usZvW+qRf2BNy/mf2zJz
        Awk3kccMXI9zrRBEj9OqzbXdfNSezDQ5HjjHT6LS8FyDxZmIIOXKhkzDg==
X-ME-Sender: <xms:7fGkY10zdI_odPkgreTYzv_tudqJCAqYYwgOAc7m-_-lhQtpW0AJWw>
    <xme:7fGkY8GIUcLGkhKclvdRQLIhK8RlTWV9IaHkUshD2mTguDqsXJ51CjwGPm1S6GB97
    tNTNSXJ7orEbZLgtZI>
X-ME-Received: <xmr:7fGkY1744GS2BQA1vrQUXQf1g2CAJQi6aoW9qJyYr6RUWLf8g2JYFA2rNozXicFjsy2GqQzfNtoeNkYL0vST>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrhedugddvtdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefhvfevufffkffojghfggfgsedtkeertdertddtnecuhfhrohhmpefvhihlvghr
    ucfjihgtkhhsuceotghouggvsehthihhihgtkhhsrdgtohhmqeenucggtffrrghtthgvrh
    hnpeetfeeikeekieeuieehffeigeetffekhedtteegkeehgefgffevfeegheevtdejheen
    ucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegtohguvg
    esthihhhhitghkshdrtghomh
X-ME-Proxy: <xmx:7fGkYy2gedJR4FCR8z1J3JL4RzRr30TS-pgzn9HJmplFfX1_PNlSuQ>
    <xmx:7fGkY4Flcc_EMbtRaevCNdyRDrfVotURtKhetHUCqjJzQyQQUms5Tw>
    <xmx:7fGkYz-6TCYLoUJhlLjdWkc8iDLDcbfZ6scBDhYX2ZyY_JYE_Z8b-g>
    <xmx:7vGkYw9acH1474Ew0-54OJnanvMx75t5XjFcltUQPJ__cMmyDerdlw>
Feedback-ID: i78e14604:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 22 Dec 2022 19:10:20 -0500 (EST)
From:   Tyler Hicks <code@tyhicks.com>
To:     gregkh@linuxfoundation.org, stable@vger.kernel.org
Cc:     "Tyler Hicks" <code@tyhicks.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Shuah Khan <shuah@kernel.org>, kvm@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
        Gavin Shan <gshan@redhat.com>, Marc Zyngier <maz@kernel.org>,
        Karolina Drobnik <karolinadrobnik@gmail.com>,
        Mike Rapoport <rppt@kernel.org>
Subject: [PATCH 5.15 2/2] KVM: selftests: Fix build regression by using accessor function
Date:   Thu, 22 Dec 2022 18:09:58 -0600
Message-Id: <20221223000958.729256-3-code@tyhicks.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221223000958.729256-1-code@tyhicks.com>
References: <20221223000958.729256-1-code@tyhicks.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Tyler Hicks" <code@tyhicks.com>

Fix the stable backport of commit 05c2224d4b04 ("KVM: selftests: Fix
number of pages for memory slot in memslot_modification_stress_test"),
which caused memslot_modification_stress_test.c build failures due to
trying to access private members of struct kvm_vm.

v6.0 commit b530eba14c70 ("KVM: selftests: Get rid of
kvm_util_internal.h") and some other commits got rid of the accessors
and made all of the KVM data structures public. Keep using the accessors
in older kernels.

There is no corresponding upstream commit for this change.

Signed-off-by: Tyler Hicks (Microsoft) <code@tyhicks.com>
---
 tools/testing/selftests/kvm/memslot_modification_stress_test.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/memslot_modification_stress_test.c b/tools/testing/selftests/kvm/memslot_modification_stress_test.c
index 1d806b8ffee2..766c1790df66 100644
--- a/tools/testing/selftests/kvm/memslot_modification_stress_test.c
+++ b/tools/testing/selftests/kvm/memslot_modification_stress_test.c
@@ -72,7 +72,7 @@ struct memslot_antagonist_args {
 static void add_remove_memslot(struct kvm_vm *vm, useconds_t delay,
 			       uint64_t nr_modifications)
 {
-	uint64_t pages = max_t(int, vm->page_size, getpagesize()) / vm->page_size;
+	uint64_t pages = max_t(int, vm_get_page_size(vm), getpagesize()) / vm_get_page_size(vm);
 	uint64_t gpa;
 	int i;
 
-- 
2.34.1

