Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5FA5C15B8D0
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 06:13:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726232AbgBMFNZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 00:13:25 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:48446 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725996AbgBMFNZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Feb 2020 00:13:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581570803;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type;
        bh=teaygsVvASctu8m9NGzjpDED1EbdyujUJNrGtqHhMtg=;
        b=c7l7VI9Rt5KLdas94g5zcdZUwePvmRBp+8Q9W+oWrl/Fj7zs7z7sFwCveqwW9Cc9Ca46KQ
        QfEZQC+Z8gnF/YoNA2YZCeBZRLrLvFep40nux/xAtWwm1jPvuuGYEKA7io7USTwcEF0r35
        PFGU9x4Wc0EPQMFBFKDahEOo3EoBQVo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-264-WFTMGAACNIaaS6tu_PqQDg-1; Thu, 13 Feb 2020 00:13:15 -0500
X-MC-Unique: WFTMGAACNIaaS6tu_PqQDg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F3CFB1088391
        for <stable@vger.kernel.org>; Thu, 13 Feb 2020 05:13:14 +0000 (UTC)
Received: from [172.54.85.204] (cpt-1024.paas.prod.upshift.rdu2.redhat.com [10.0.19.50])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 494191001281;
        Thu, 13 Feb 2020 05:13:12 +0000 (UTC)
MIME-Version: 1.0
From:   CKI Project <cki-project@redhat.com>
To:     Linux Stable maillist <stable@vger.kernel.org>
Subject: =?utf-8?b?4p2M?= FAIL: Test report for kernel 5.4.20-rc1-702104a.cki
 (stable)
Date:   Thu, 13 Feb 2020 05:13:11 -0000
Message-ID: <cki.508D8FAD58.PHXLF4GSH5@redhat.com>
X-Gitlab-Pipeline-ID: 434817
X-Gitlab-Url: https://xci32.lab.eng.rdu2.redhat.com
X-Gitlab-Path: /cki-project/cki-pipeline/pipelines/434817
Content-Type: multipart/mixed; boundary="===============1935745309069836268=="
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--===============1935745309069836268==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit


Hello,

We ran automated tests on a recent commit from this kernel tree:

       Kernel repo: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
            Commit: 702104a8260f - Linux 5.4.20-rc1

The results of these automated tests are provided below.

    Overall result: FAILED (see details below)
             Merge: OK
           Compile: FAILED

All kernel binaries, config files, and logs are available for download here:

  https://cki-artifacts.s3.us-east-2.amazonaws.com/index.html?prefix=datawarehouse/2020/02/13/434817

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


--===============1935745309069836268==
Content-Type: application/x-xz
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="build-aarch64.log.xz"
MIME-Version: 1.0

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

--===============1935745309069836268==--

