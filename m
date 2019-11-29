Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 138B410DA7F
	for <lists+stable@lfdr.de>; Fri, 29 Nov 2019 21:14:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727076AbfK2UOh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Nov 2019 15:14:37 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:48344 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726926AbfK2UOh (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Nov 2019 15:14:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575058475;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type;
        bh=AvS1zvdYkbVS7LVHXQC+f/kysf6559OKTY3cBKQ/ui8=;
        b=TdRqxrQAMotEr2hR3q7GQPlHxUlshiSkanXxLau7thBdUaQGJxAYoH8h9+yG76hBqRj+9O
        u0GqrA6f/gdKKz3WWw5qMVz4OSJwzG66PHIFOfvlOuQ8oF3LMb2AzskELjNyGJtC9m7qGc
        vKImMN7ZqJTlB4IpiDbUG0wkfzquBxI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-301-LBRzP4Y5M1yzmOfvbBoMaw-1; Fri, 29 Nov 2019 15:14:31 -0500
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6DABE18543A0
        for <stable@vger.kernel.org>; Fri, 29 Nov 2019 20:14:30 +0000 (UTC)
Received: from [172.54.108.34] (cpt-1042.paas.prod.upshift.rdu2.redhat.com [10.0.19.67])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A4BDA6090C;
        Fri, 29 Nov 2019 20:14:28 +0000 (UTC)
MIME-Version: 1.0
From:   CKI Project <cki-project@redhat.com>
To:     Linux Stable maillist <stable@vger.kernel.org>
Subject: =?utf-8?b?4p2M?= FAIL: Test report for kernel  (stable-queue)
Date:   Fri, 29 Nov 2019 20:14:28 -0000
Message-ID: <cki.9578F1D62E.HA5UQQZXEC@redhat.com>
X-Gitlab-Pipeline-ID: 315133
X-Gitlab-Url: https://xci32.lab.eng.rdu2.redhat.com
X-Gitlab-Path: /cki-project/cki-pipeline/pipelines/315133
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-MC-Unique: LBRzP4Y5M1yzmOfvbBoMaw-1
X-Mimecast-Spam-Score: 0
Content-Type: multipart/mixed; boundary="===============3731388268853891401=="
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--===============3731388268853891401==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit


Hello,

We ran automated tests on a recent commit from this kernel tree:

       Kernel repo: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
            Commit: 04eb6cf525b2 - Linux 5.3.14

The results of these automated tests are provided below.

    Overall result: FAILED (see details below)
             Merge: OK
           Compile: FAILED

All kernel binaries, config files, and logs are available for download here:

  https://artifacts.cki-project.org/pipelines/315133

We attempted to compile the kernel for multiple architectures, but the compile
failed on one or more architectures:

           aarch64: FAILED (see build-aarch64.log.xz attachment)
           ppc64le: FAILED (see build-ppc64le.log.xz attachment)
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

    ppc64le:

    x86_64:


--===============3731388268853891401==
Content-Type: application/x-xz
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="build-ppc64le.log.xz"
MIME-Version: 1.0

/Td6WFoAAATm1rRGAgAhARYAAAB0L+WjAQAIYnVpbGQubG9nAAAAAG7M3kpeYfe/AAEhCWwYxdUf
tvN9AQAAAAAEWVo=
--===============3731388268853891401==
Content-Type: application/x-xz
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="build-aarch64.log.xz"
MIME-Version: 1.0

/Td6WFoAAATm1rRGAgAhARYAAAB0L+WjAQAIYnVpbGQubG9nAAAAAG7M3kpeYfe/AAEhCWwYxdUf
tvN9AQAAAAAEWVo=
--===============3731388268853891401==
Content-Type: application/x-xz
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="build-x86_64.log.xz"
MIME-Version: 1.0

/Td6WFoAAATm1rRGAgAhARYAAAB0L+WjAQAIYnVpbGQubG9nAAAAAG7M3kpeYfe/AAEhCWwYxdUf
tvN9AQAAAAAEWVo=
--===============3731388268853891401==--

