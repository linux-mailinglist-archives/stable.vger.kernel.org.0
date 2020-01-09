Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38DB1136283
	for <lists+stable@lfdr.de>; Thu,  9 Jan 2020 22:30:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725840AbgAIVaq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Jan 2020 16:30:46 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:30641 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725763AbgAIVaq (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Jan 2020 16:30:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578605445;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type;
        bh=1IUjlo6h+sZStx42VL9j/a6mBCI3UCW9wRCGNoHJVX8=;
        b=PZJGYjfsz7Xs7moPBiTWYljPdliqaL43FBklIgl1fpHorXJsTGmbMkNN8HzdYzkFW3Ky+4
        qKRk7GW2vO7LNLt0r7jUEnJhGvoeI0aTfr8lH1LeIF6gXuepUCbc+N21g3PorNc2pIJIdK
        wDCXe2seNfMaBVF5JtAqnsmW9sG4Emc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-390-a4zBthMkNV-7d4xcXbW_iw-1; Thu, 09 Jan 2020 16:30:41 -0500
X-MC-Unique: a4zBthMkNV-7d4xcXbW_iw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8657C107ACC4
        for <stable@vger.kernel.org>; Thu,  9 Jan 2020 21:30:40 +0000 (UTC)
Received: from [172.54.108.255] (cpt-1042.paas.prod.upshift.rdu2.redhat.com [10.0.19.67])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DB8075C545;
        Thu,  9 Jan 2020 21:30:37 +0000 (UTC)
MIME-Version: 1.0
From:   CKI Project <cki-project@redhat.com>
To:     Linux Stable maillist <stable@vger.kernel.org>
Subject: =?utf-8?b?4p2M?= FAIL: Test report for kernel 5.4.11-rc1-c2277d0.cki
 (stable)
Date:   Thu, 09 Jan 2020 21:30:37 -0000
Message-ID: <cki.2D14222D64.0OY8ZIUAF0@redhat.com>
X-Gitlab-Pipeline-ID: 374903
X-Gitlab-Url: https://xci32.lab.eng.rdu2.redhat.com
X-Gitlab-Path: /cki-project/cki-pipeline/pipelines/374903
Content-Type: multipart/mixed; boundary="===============4389216519533175408=="
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--===============4389216519533175408==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit


Hello,

We ran automated tests on a recent commit from this kernel tree:

       Kernel repo: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
            Commit: c2277d07f243 - Linux 5.4.11-rc1

The results of these automated tests are provided below.

    Overall result: FAILED (see details below)
             Merge: OK
           Compile: FAILED

All kernel binaries, config files, and logs are available for download here:

  https://artifacts.cki-project.org/pipelines/374903

We attempted to compile the kernel for multiple architectures, but the compile
failed on one or more architectures:

           aarch64: FAILED (see build-aarch64.log.xz attachment)

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


--===============4389216519533175408==
Content-Type: application/x-xz
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="build-aarch64.log.xz"
MIME-Version: 1.0

/Td6WFoAAATm1rRGAgAhARYAAAB0L+WjAQAIYnVpbGQubG9nAAAAAG7M3kpeYfe/AAEhCWwYxdUf
tvN9AQAAAAAEWVo=

--===============4389216519533175408==--

