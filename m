Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A35B4595A6D
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 13:42:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233847AbiHPLmT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 07:42:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234452AbiHPLlr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 07:41:47 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB655BD17C
        for <stable@vger.kernel.org>; Tue, 16 Aug 2022 04:11:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660648296;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=4GAw0vGfG+KnFhJ4tsA37s0KIuHGEaGKRQ7Ef12sysM=;
        b=RwhU2Hqm/uKO+Fr3gSGt1G7g4DWx5eTJ2PDAIkVpjM2IP/4u/INSu57Xu2fB9hYq2H5bpC
        78ZnRSEM8Hfgh4muE9BtV4fhmZ/YG8seBBP+xeFnSRILeVUH6uHG2uWmwQk2Xs7quA1I9p
        s6/h+e44uopAZ1k8xiq6tWgzpMRo3fY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-370-ZnH-nHs8PA62Wtt3R1fwAQ-1; Tue, 16 Aug 2022 07:11:35 -0400
X-MC-Unique: ZnH-nHs8PA62Wtt3R1fwAQ-1
Message-Id: <90999.122081607113500782@us-mta-370.us.mimecast.lan>
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D0C6385A588
        for <stable@vger.kernel.org>; Tue, 16 Aug 2022 11:11:34 +0000 (UTC)
Received: from [172.64.12.33] (unknown [10.30.32.158])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C361C2166B29;
        Tue, 16 Aug 2022 11:11:34 +0000 (UTC)
From:   cki-project@redhat.com
To:     stable@vger.kernel.org
Subject: =?utf-8?b?4p2M?= FAIL: Test report for db224daa (stable-queue)
Date:   Tue, 16 Aug 2022 11:11:34 -0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        MSGID_FROM_MTA_HEADER,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
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
    https://datawarehouse.cki-project.org/kcidb/checkouts/40813

One or more kernel builds failed:
    Unrecognized or new issues:
          x86_64 - https://datawarehouse.cki-project.org/kcidb/builds/217432


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

