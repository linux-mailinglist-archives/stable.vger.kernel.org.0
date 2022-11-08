Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 496A1620528
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 01:52:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233050AbiKHAwB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Nov 2022 19:52:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232391AbiKHAv5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Nov 2022 19:51:57 -0500
Received: from smtp-fw-9102.amazon.com (smtp-fw-9102.amazon.com [207.171.184.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66D3C1F2C4;
        Mon,  7 Nov 2022 16:51:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1667868717; x=1699404717;
  h=from:to:cc:subject:date:message-id:
   content-transfer-encoding:mime-version;
  bh=kzicRcG+TGEY2Z8XrFFSHck2JvbpK3yaDfDkTtu37vI=;
  b=Vd0AaoGY9gfnW4Y6xY/Y1mz/hQKCX/QH0hHAd2p5sL2poCQjOb12sHDE
   DP978IyqVV+kQM8LkE486EDIoQNtslkamvZZcPDyVuvuohhJsKDA9pOZj
   YRwSLrd5LBm7GWNFr7x+6P9TMbpSItlgquBjhza3Yvs5TRI/ciQaUzWly
   Y=;
X-IronPort-AV: E=Sophos;i="5.96,145,1665446400"; 
   d="scan'208";a="277860468"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-iad-1e-m6i4x-0aba4706.us-east-1.amazon.com) ([10.25.36.210])
  by smtp-border-fw-9102.sea19.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2022 00:51:51 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-iad-1e-m6i4x-0aba4706.us-east-1.amazon.com (Postfix) with ESMTPS id EA302A0F97;
        Tue,  8 Nov 2022 00:51:48 +0000 (UTC)
Received: from EX19D045UWC001.ant.amazon.com (10.13.139.223) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.42; Tue, 8 Nov 2022 00:51:48 +0000
Received: from EX19D017UWC003.ant.amazon.com (10.13.139.227) by
 EX19D045UWC001.ant.amazon.com (10.13.139.223) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.15; Tue, 8 Nov 2022 00:51:48 +0000
Received: from EX19D017UWC003.ant.amazon.com ([fe80::78e9:1d67:81fd:68c5]) by
 EX19D017UWC003.ant.amazon.com ([fe80::78e9:1d67:81fd:68c5%6]) with mapi id
 15.02.1118.015; Tue, 8 Nov 2022 00:51:48 +0000
From:   "Lu, Davina" <davinalu@amazon.com>
To:     Theodore Ts'o <tytso@mit.edu>
CC:     "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
        "adilger.kernel@dilger.ca" <adilger.kernel@dilger.ca>,
        "regressions@lists.linux.dev" <regressions@lists.linux.dev>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Mohamed Abuelfotoh, Hazem" <abuehaze@amazon.com>,
        hazem ahmed mohamed <hazem.ahmed.abuelfotoh@gmail.com>,
        "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
        "Kiselev, Oleg" <okiselev@amazon.com>,
        "Liu, Frank" <franklmz@amazon.com>
Subject: configurable lazytime for EXT4, is name ok?
Thread-Topic: configurable lazytime for EXT4, is name ok?
Thread-Index: AdjzC8FGHNuLQ/rLSpuMIprsbw2tdw==
Date:   Tue, 8 Nov 2022 00:51:47 +0000
Message-ID: <173aa5e092bc4f3a8a49be9c095a7d6e@amazon.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.43.143.133]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-Spam-Status: No, score=-14.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Ted,

Sorry to bother you with a quick question: I am doing a patch for configura=
ble lazytime for EXT4, Before submit the patch I would like to double check=
 the names first. I added a "lazytime_flush=3Dxxx" in mount show options, n=
ot sure if this is ok to continue.=20

As far as I know, lazytime is an option for EXT4 and other file systems. My=
 patch make ext4 can be supported as before: without any parameters E.g. mo=
unt -o lazytime,...=20
Or can be supported with parameters (in ms) E.g. mount -o lazytime=3D30, ..=
.=20

So when we show the options by mount -t ext4, if no parameter configured, t=
he result shows as before:
/dev/nvme1n1 on /rdsdbdata1 type ext4 (rw,noatime,nodiratime,lazytime,data=
=3Dordered)

If has parameters configured, the result shows as below, added one "lazytim=
e_flush=3Dxxx". Not sure if this sound ok for you?=20
/dev/nvme1n1 on /rdsdbdata1 type ext4 (rw,noatime,nodiratime,lazytime,lazyt=
ime_flush=3D100ms,data=3Dordered)

I tested "ext4/053"of latest xfstest-dev with my patch and it can pass the =
result(I changed a bit 053 since I am running on 5.10, removed one mount op=
tion" no_prefetch_block_bitmaps" that  5.10 doesn't support).

Thanks
Davina
