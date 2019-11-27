Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BAE1D10BA71
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:03:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732006AbfK0VDO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 16:03:14 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:39905 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1732011AbfK0VDN (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Nov 2019 16:03:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574888592;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type;
        bh=jv24lZM6sctS34tmimJiD5vACaxxgM8JBckGttK9dAk=;
        b=InOjSmdioPll9am8LKS54SuSTfXphIZu7/FBwJ4SyMV30CbuTbVNAl6JabIhditX6Nvs4Q
        QHh7DRHVQ+fnon1tJY1G7ymjjFxN8JACXR5P1r312Is7JfGL3a0c+W1RCn6ews5ySD2sQE
        yJ3H3J1cgS/zU/n+9OXjbydlnOto1cQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-24-niqkjWwGNBKiwpfKP_4MCA-1; Wed, 27 Nov 2019 16:01:06 -0500
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 32F0E1800D52
        for <stable@vger.kernel.org>; Wed, 27 Nov 2019 21:01:05 +0000 (UTC)
Received: from [172.54.88.80] (cpt-1048.paas.prod.upshift.rdu2.redhat.com [10.0.19.70])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B610BA7FF;
        Wed, 27 Nov 2019 21:01:04 +0000 (UTC)
MIME-Version: 1.0
From:   CKI Project <cki-project@redhat.com>
To:     Linux Stable maillist <stable@vger.kernel.org>
Subject: =?utf-8?b?4p2M?= FAIL: Test report for kernel 5.3.13-0a4cde6.cki
 (stable-queue)
Date:   Wed, 27 Nov 2019 21:01:04 -0000
Message-ID: <cki.FF9D569258.RKG14NB0SC@redhat.com>
X-Gitlab-Pipeline-ID: 311814
X-Gitlab-Url: https://xci32.lab.eng.rdu2.redhat.com
X-Gitlab-Path: /cki-project/cki-pipeline/pipelines/311814
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-MC-Unique: niqkjWwGNBKiwpfKP_4MCA-1
X-Mimecast-Spam-Score: 0
Content-Type: multipart/mixed; boundary="===============4313803134789112060=="
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--===============4313803134789112060==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit


Hello,

We ran automated tests on a recent commit from this kernel tree:

       Kernel repo: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
            Commit: 0a4cde60262d - KVM: PPC: Book3S HV: Flush link stack on guest exit to host kernel

The results of these automated tests are provided below.

    Overall result: FAILED (see details below)
             Merge: OK
           Compile: FAILED

All kernel binaries, config files, and logs are available for download here:

  https://artifacts.cki-project.org/pipelines/311814

We attempted to compile the kernel for multiple architectures, but the compile
failed on one or more architectures:

            x86_64: FAILED (see build-x86_64.log.xz attachment)

We hope that these logs can help you find the problem quickly. For the full
detail on our testing procedures, please scroll to the bottom of this message.

Please reply to this email if you have any questions about the tests that we
ran or if you have any suggestions on how to make future tests more effective.

        ,-.   ,-.
       ( C ) ( K )  Continuous
        `-',-.`-'   Kernel
          ( I )     Integration
           `-'
______________________________________________________________________________

Compile testing
---------------

We compiled the kernel for 3 architectures:

    aarch64:
      make options: -j30 INSTALL_MOD_STRIP=1 targz-pkg

    ppc64le:
      make options: -j30 INSTALL_MOD_STRIP=1 targz-pkg

    x86_64:
      make options: -j30 INSTALL_MOD_STRIP=1 targz-pkg


--===============4313803134789112060==
Content-Type: application/x-xz
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="build-x86_64.log.xz"
MIME-Version: 1.0

/Td6WFoAAATm1rRGAgAhARYAAAB0L+WjAQAIYnVpbGQubG9nAAAAAG7M3kpeYfe/AAEhCWwYxdUf
tvN9AQAAAAAEWVo=
--===============4313803134789112060==--

