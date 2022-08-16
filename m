Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0E74595A6C
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 13:42:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233569AbiHPLmL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 07:42:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233971AbiHPLln (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 07:41:43 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF66FBCCCB
        for <stable@vger.kernel.org>; Tue, 16 Aug 2022 04:11:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660648291;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=NhdZvCcuQ3U09qdIxtJvfiKWxsydIekTh9pSpU8QYW0=;
        b=UlpGdTZ79y6ahAGoAX7FxY07VB3Csf4e7EQBJaFYgFBw7pRSFH0cp34jKoHWgk6B5Q2NDU
        MFzyZmdN1tlRrJiguX1o5ig6XSrrjpJzqybEpxBKwH6AMenb7jSO1sALDe4SmxwxsRe5Zq
        wLBfiLDzzQCBpJDdnoCOtvvomI15R78=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-447-f8djc4f7OAuuJAe49UdUoQ-1; Tue, 16 Aug 2022 07:11:30 -0400
X-MC-Unique: f8djc4f7OAuuJAe49UdUoQ-1
Message-Id: <36519.122081607113000579@us-mta-447.us.mimecast.lan>
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2D4F5803301
        for <stable@vger.kernel.org>; Tue, 16 Aug 2022 11:11:30 +0000 (UTC)
Received: from [172.64.12.33] (unknown [10.30.32.158])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 212B640CFD0A;
        Tue, 16 Aug 2022 11:11:30 +0000 (UTC)
From:   cki-project@redhat.com
To:     stable@vger.kernel.org
Subject: =?utf-8?b?4p2M?= FAIL: Test report for 3e889f78 (stable-queue)
Date:   Tue, 16 Aug 2022 11:11:29 -0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        MSGID_FROM_MTA_HEADER,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi, we tested your kernel and here are the results:

    Overall result: FAILED
             Merge: OK
           Compile: FAILED


You can find all the details about the test run at
    https://datawarehouse.cki-project.org/kcidb/checkouts/40850

One or more kernel builds failed:
    Unrecognized or new issues:
          x86_64 - https://datawarehouse.cki-project.org/kcidb/builds/217550


If you find a failure unrelated to your changes, please tag it at https://dat=
awarehouse.cki-project.org .
This will prevent the failures from being incorrectly reported in the future.
If you don't have permissions to tag an issue, you can contact the CKI team or
test maintainers.

Please reply to this email if you have any questions about the tests that we
ran or if you have any suggestions on how to make future tests more effective.

        ,-.   ,-.
       ( C ) ( K )  Continuous
        `-',-.`-'   Kernel
          ( I )     Integration
           `-'
______________________________________________________________________________

