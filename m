Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CFDC6A795B
	for <lists+stable@lfdr.de>; Thu,  2 Mar 2023 03:10:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229504AbjCBCKC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Mar 2023 21:10:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbjCBCKA (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Mar 2023 21:10:00 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36FF03400A
        for <stable@vger.kernel.org>; Wed,  1 Mar 2023 18:09:59 -0800 (PST)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 321MpXfP011760;
        Thu, 2 Mar 2023 02:07:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=corp-2022-7-12;
 bh=jqMD/QQE9q3M8VexduiJV2GH5wVqsz78UvWC21OFrlY=;
 b=xJdLVlv0T1mzmO8V2wY/OyrdGUSxXb2ICu1US2C0YMgD4Lx2ANMQQV3+V50MP3PoKDee
 1utQXmrV00Mbwj1xD+8ktn66+RRNygTkvZoVhjc+H494BNmZ/kjm0QurOiqGaMhOC2gQ
 aKQ3B1mhYLPF3axROwxE+ZJDRoaKg/7jCTtYJQ+KOU7I6EIEpDZ6y91WSXge6vyazQv6
 xbQng62VT8xXZalCbkX6eticpuOto7ZEgTrNNfDcBVfNtjCFge2cv1hJwVei5jSMny+H
 OMznr9QT6qPHPUlH/swTWxyTEj+Izh1waSoU7PgwMmXazboMM/UZ6SlgJ4Dx/gqm3P+F mw== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3nyb7wth8v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 02 Mar 2023 02:07:16 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 3221tMXB031632;
        Thu, 2 Mar 2023 02:07:14 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2168.outbound.protection.outlook.com [104.47.55.168])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3ny8sg6va9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 02 Mar 2023 02:07:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R9hi4CfAqG6rFdRYFdkOi2GWixbkLfj75v/eL4LcFaVZF8HDiZjp/ypXA72tWw42aHpGAp338BA2cT/u9WKNZAD7CKYGkjRfjB7vxbc6//54+KyipnpXwrbycMSChluvErauEsebNyXYV/84PU6wdCeKsizgTT0cXXY624rsEPPL4XEKt1ud9ywE/X2iyfePKqwKIW9UI2S1DizqFnCa/J0GFUNYrJ40vYquIag9QW4bFLHXnCEywaJz0t6BtSFwp8nzvFrzkk870m64PyqdvDQ1mD6+K/wpfWM/8R49gyqV7CjKM3KrO/MZOMqanvncYl+RFtTy3U0BHawxzXTeBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jqMD/QQE9q3M8VexduiJV2GH5wVqsz78UvWC21OFrlY=;
 b=FfjDQLe0alqM2U/Wh/bwWkCT+CxUjZwbZ+7r1o7z9hV958dKRkCdFsloxns9jr5c2l6PGWTwP2GHMnkDb2nlmfamIxEAUmCfExB39eEA2PtG2EPhXwEM3AqFwI0OjoZqaORysvK+V7joWeHFhDo50XG+7ZlgDXKMrHCg0B58lwQf3eYBxpmefrEw2w4h419t4NeEZnWrlX4kZ+lCFlcfCHbo0KGFMPCpPv/tqxj3UXjl8vgXq6PsMBANRIykWMhND6SoL394PY/sDfb0SwjI49QKrCdy1wyhXOTv2JrxTYX7bvebIBL2YHu72jvKKU1nAWbMF9+1083GVBYiqDGY1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jqMD/QQE9q3M8VexduiJV2GH5wVqsz78UvWC21OFrlY=;
 b=gQFt8E80JT0PCyBKRQHUr3sEX3yfxHzUyjR/FQw0ADXwch6lREZ9nDITFmAv2e1ijusFugpK4Id4sT0K7K1QZWd9G/PFqXa/zMah5Qo4uJMUDnD14v5g/j+pA0TLhLOcAZ9rAIjVwFs9RVAyJdhS+Ccq07HiAh7q1kxU05axpEo=
Received: from BY5PR10MB3794.namprd10.prod.outlook.com (2603:10b6:a03:1b2::30)
 by DM6PR10MB4284.namprd10.prod.outlook.com (2603:10b6:5:21f::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.19; Thu, 2 Mar
 2023 02:07:12 +0000
Received: from BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::df97:c045:6f0c:974f]) by BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::df97:c045:6f0c:974f%3]) with mapi id 15.20.6156.018; Thu, 2 Mar 2023
 02:07:12 +0000
From:   Tom Saeger <tom.saeger@oracle.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        Tom Saeger <tom.saeger@oracle.com>, stable@vger.kernel.org,
        "H.J. Lu" <hjl.tools@gmail.com>, Kees Cook <keescook@chromium.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Dennis Gilmore <dennis@ausil.us>,
        Ard Biesheuvel <ardb@kernel.org>,
        Palmer Dabbelt <palmer@rivosinc.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Nathan Chancellor <nathan@kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
        Arnd Bergmann <arnd@arndb.de>, Christoph Hellwig <hch@lst.de>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        Rich Felker <dalias@libc.org>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.4 v3 0/6] Fix Build ID on arm64 if CONFIG_MODVERSIONS=y
Date:   Wed,  1 Mar 2023 19:06:58 -0700
Message-Id: <20230210-tsaeger-upstream-linux-stable-5-4-v3-0-122fc5440d4c@oracle.com>
X-Mailer: git-send-email 2.39.2
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.12.1
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: SJ0PR13CA0112.namprd13.prod.outlook.com
 (2603:10b6:a03:2c5::27) To BY5PR10MB3794.namprd10.prod.outlook.com
 (2603:10b6:a03:1b2::30)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB3794:EE_|DM6PR10MB4284:EE_
X-MS-Office365-Filtering-Correlation-Id: cf2cbc52-2783-4901-6b61-08db1ac2d649
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OV2AyTz/QIG7D3sUrw41Rb2K8XVViWc6Y8/q53ccxKKk4KMj8gcRZ6U5BarNMp2UYHuYlcpC99/L6HrVj4u/6fkjHSx98t38q/Ax43elyikMHU8GO5Pkbql00aDFSJ4rz0dRcdaW1C/8nN+JeUdrClKu4K39//iN2q9/EhxAOmGioeg8SGVE8oN0LT/6M1WBDQbpzw4dU0UE4cG40lEgVUkEOUaXnX1rdVE+lbhbDKaLS0fQj6bGHAJUlOe67avWjt179h5BtYTTIxQsKlYHTieyYa6Gn43JqGQgMZ7aqmpagfrIjZhLpGoO+x9BIVTZ1f3rtKOYwVXFjCjwZFCYqAMbZfe0HqL975s97o5oPGOmEtfHsmri2MpPUGJGlLYbannFmiowijRsetKHTqhEbjK4k1Oe6xk5Fjf/rXZfTOpHcl6ojGXAEUWj9lKFVga9GCth+DISQ+qSL2raZ7M8kfN0KmlZTOTfs2ki7bSN7iMfuOUrCSUBTOqAQVyFbduXFGBvCJxqJO5ldGCdCcW5XNrBYds7JJaXq1q06z+lJ0d9UNtO77/rIlzGTtYq0AP4oYssFK7iGH8ldZ2wELsP6hTM5IEpM4wmEmr74xgJR5xanUvLita2VEkBImFe4AaxNc6g1YoX3wSEK5nn6fVKPDI2u+lrvcJPoI2mYu7mok8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB3794.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(39860400002)(136003)(366004)(346002)(396003)(451199018)(5660300002)(44832011)(83380400001)(41300700001)(4326008)(6916009)(66476007)(66556008)(8676002)(8936002)(7416002)(66946007)(316002)(54906003)(38100700002)(966005)(36756003)(2906002)(6486002)(6512007)(86362001)(6506007)(26005)(186003)(6666004)(478600001)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NWFaY1lRMk1FTm5Pa2RWazVMNVBWQTdyQkVjNXBpRERBdlRnekpnNFROOXM3?=
 =?utf-8?B?c3ZmL3VpWEhSK3d6WnBxK0JwbFluNlhGbUxmRUVXdnN6ckJLemNDV3FzOWtS?=
 =?utf-8?B?SmY3OWlEaCtrNnA2UlJ6ejBqWHJVNE9ER1UyaFU3UGJWWGg0aitRdUdrcStv?=
 =?utf-8?B?RHUwaXB0OHBVVTJ1ZUxxVCs1c3h3WXBWQkgydGJxTGMyZVhaUGJLalMrSXRQ?=
 =?utf-8?B?WjJPVmF4VGt2enk2c1JlSEoyNjN3ODFocUptSDlXU1pYWFhBUzFRT0tsQ2NZ?=
 =?utf-8?B?NkJUcEpMQytGUU5KbzZJRTEyR2l5YUpjWnEwaGJmRTZpZFl0NjZUYWJmVzRC?=
 =?utf-8?B?aFVkRjh1WExOQ0lTYVNsWCtxc1pITTNqWDZUZnB3S2dxbS9yaDg0K2ZYN0l5?=
 =?utf-8?B?b0JNZnZNdnVQdE8xeGtvbkwwZjZCMlBwdkI3aUFwOWMvUUJzTTA2UTJaWUJ6?=
 =?utf-8?B?U1RsME1aMkZ2WEFUaDkxQTdVZEZXVGZ0ZHBtWStKbGU3alFKYlp1dHVhVUcv?=
 =?utf-8?B?ZnlQVi9LTGR6cEtvVHNkcE5XaGEzaVM1S0h3RktQYkpsaVBqSUsydTJlejB3?=
 =?utf-8?B?U3FWL0VTeFN1K052dlg3RkxOV3VGcE5YNVlBbGNQUG0wQ2RDNU5RVWNnV0NF?=
 =?utf-8?B?aGZpLzI0VW1GQUZmdHVydG9qNFpvOTFsa2YxZlgyZC9NelUvWFAxc2xJdi9C?=
 =?utf-8?B?WGFCKzJTK0FYUFZ4SnNINW5uVkltQ2tHRGtIcjMzRjIxd3JsbG9CeXFzVzlo?=
 =?utf-8?B?ZWhKZHdnRUxMeUZnTE85V2JBRHdDVm12cklOVm51NjVTMDROY0dvKzFUT04r?=
 =?utf-8?B?bm1Gb21kRmVkTEpxTFBCcnBuTVdTRjFLbWFONmJNc0ViVTBIa2FmdnFoSVNk?=
 =?utf-8?B?dEFVZWU5NTFJbUlDbU12b0xMSG5rT1I3Ukd0RnlEL3JlK0J0K1Q4NmNZM2hT?=
 =?utf-8?B?V1d1NXpEVHZHTzR0QjUrazhLeUczS0dsSHNpZ0VpNWxNS0I5bGpqR1NIeHRs?=
 =?utf-8?B?WUxxTG5HZ1pjaExRN2daMThPVmJhLzlRcmRHWUxJaVFZTzdWbnJmbHBERWlq?=
 =?utf-8?B?K21Xa1pYbFYxaWxZWk9ac1ExWmhOYkpwREVzaVFzRlp6Z2xVcmNQeFdrRGhG?=
 =?utf-8?B?b0ZuY28rYXgzZUtReEVYOTRnZXIwN1h0RHdTcGYxSzlVSGw4ZDlRL1hRcndM?=
 =?utf-8?B?cFlkMHZDUE5mVkMxbVJGc2JLZ0szbUQwemdlRjJJVlB3VzhybDAxZS9TSEFw?=
 =?utf-8?B?Y0puOUdMQ0xCRHNGdnRpNzlYMHpYTmFla3kvbmZzVHYzRkQrZTdRcG5JekxG?=
 =?utf-8?B?UC9wYVpZZ2wxcU9hNXM4QkxSNGNxcWlNNEU1MWZtNzFjT2Y3Y3NMMHFhenFq?=
 =?utf-8?B?QTVLdEY4a0ZVZllZc3JCV2wwT2lhbHlhc3FjTVFkWlBqRDBURVVZclYzSXBv?=
 =?utf-8?B?eEhQTDZ3d3hFNWNodTg5bUZER2N6NTQvSlJ5MEhZZkJ1UThYL2x6RkJLMTBX?=
 =?utf-8?B?SlU1UEtzVVJ0L21OOHkyTFFVR3BOVXdvWEgrSit1STl2TSt3SUdjbkE1Z0do?=
 =?utf-8?B?dEVSZjhYVll1WDlDUEV0eHhGSDdjeXQyd2pKdFhmUWRURDlHSDdpVm5KdjV4?=
 =?utf-8?B?QUVCb3NaYWFUUDdRckc4anVnZEtKUWt0ODQyY2FYalQxUW1HcG95dTlqZDg2?=
 =?utf-8?B?ajZpOHVKMFVQY2drRnRJR05mTVNUL25xclNJTnVzM1BYeDF6eEFNbXAva21D?=
 =?utf-8?B?eDUxbGUxZUhveGN2YVVIYnF1R0lCUXJqN0RKT1lTT1VBZTNjdy8rL1h3OGtC?=
 =?utf-8?B?UnBCaW53K2x4YVFBN1llQjl1ODZxNFhENUt6eWVoSnkvVWhTWWpJZTBzYjZo?=
 =?utf-8?B?cktFKzF5UHJJZ0tBTWZpM3lid1ZWSGNDNVlidU95WjlPYkRDMzNRQi9GQ2Rq?=
 =?utf-8?B?R0xUNEM4SEJsNXJKZXk5R3I2a3JEdm9YTnUwUkVtekxBd3dYcVpUdUFBRnpK?=
 =?utf-8?B?aW9JTjlWcjdJRVNla1cwZDlBMWJqbGxIRzc3cGM5VFo3L0g4dDF5ZVQzVGJ3?=
 =?utf-8?B?SDFlS1BOaWVMR0oxY1pGS1FpQjZHMHZ2L3I5Q2dtWWxGaUpUR0JscUpMQTIw?=
 =?utf-8?B?dFY1ZzJrTEVObzVmcC9KRjBqZlgrYnE5UTdHa081NlE2QTBGNzJhVmNTRlcy?=
 =?utf-8?B?SlE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?Q2JVaHpvYW8vUzRwVCszMHFMRWJWM1R0SGtvaGgzbjZucS8ySmpLSENCbGc1?=
 =?utf-8?B?UjE0elN3ZUZ4dFJvOHhjVUl0UHBIdHV6bzJKVzVBS3hacHZ1d2l6WFNESUYy?=
 =?utf-8?B?MFdDa0dPT2ZKUkNGZm9JbTZzdCs4Y2hKT3pqRlpWaTV0eStLeXA0bXM4SHY2?=
 =?utf-8?B?clZhODRQZkNvUVcybHVIK3hubWlQaHc5Y3Q1RmVmQUVNWFNkNmFXUk5PNzdS?=
 =?utf-8?B?bndOUDZETjJEdXlMQ0NnY0FIamhKRytMSWlsaGx6UFdVeXllTmRvcTF5dlNT?=
 =?utf-8?B?eHFRbmhOYTBvZUZlWDh4cFBLVkJNVG1ybXRtR2hYUmlDbVNKa1pCRnA0RkM3?=
 =?utf-8?B?RDc5R3F1NUVLcnRvVWFaaVZxWmgzQ0h4TEtld2JsTEM3L1hKUVh0RkgvcFhY?=
 =?utf-8?B?bnFISzNub1N2aXMyRytVbWM3SElRODJFeFRGdGVMbzF2SE8zMWFDalZUNXdm?=
 =?utf-8?B?cEVjSGgrSTRsVnpYVk5qaEc3V0ZJaFBWazJxeklUeHBDd3hSVFJUMWdGeVhq?=
 =?utf-8?B?N2FMQ2lrMndIS3RIakk5K3dLc0NiaVlxZUQ3RFNROFQ4dHJMMWVtTGhQcnha?=
 =?utf-8?B?M2ZoSzdVcmJkclJLajRjaWVTc1NqaFg2aHZ2RkNFdUUvOW8vTjI1b0ZuaGJM?=
 =?utf-8?B?eUFwWGZaMmx6V3FlS3N1bFpPSU9nRDdOZlhYT09td2l4OHR0alFRVTZQQW12?=
 =?utf-8?B?bDkzMmpyWDdtbDV1ZDdYL2JkWmY0V3lWUHJzQjFkZEdkY2VjYVMxUE9pSkFu?=
 =?utf-8?B?OUVuZUtXL09ZR01IRlc3YSs4bUFhVlhIczREZzI3SjNpK0ErQTVNcmp6ZkRF?=
 =?utf-8?B?c2JOTUxlYlBZSTdyUWxBSGRycWdpYUN3bmQ1d1RhT2dJRkZETFgraTZFUDVz?=
 =?utf-8?B?WWVyN000QmZPZkhodTJJQW01R1diMlJFamF5VjNxekk3UGVhQnUyNCtmT2Zh?=
 =?utf-8?B?emY5bGVhWVNmZGVOS0JTOGxVL1VzbG5pdlEvYkRFZUZLUFJWL0lidmNHNFZQ?=
 =?utf-8?B?NVRCMXUzYXE0cDR6WGlSZXZMZW9zb09hWWplMzVJZHdSeHQ5UFBZaVk4dDRC?=
 =?utf-8?B?RDBOalNiNlE1NGpNWFE0T3N0T05xcGphelU5QzVCZmEyWjdSVnRGeWs1bTZt?=
 =?utf-8?B?SHhVRVhnRUZxN3RpTHRpMnNONEZMQkNCVkNSMUcwbTZQZTRROGVRb1FWTnFs?=
 =?utf-8?B?Y2JaUSt4c0dUc1RPd0g4TjZlc0ZTY0V3c2JNOEZtL1MvbGxoN1Z4RUk5OS8v?=
 =?utf-8?B?K0FVa3hxQXpTbjUyL3B3YnNKa2NjZ1hrVVh5ZUM0U2VuZVZLaG1qLzlTdDFC?=
 =?utf-8?B?aE50TEozbzhHa1JCNmEyODRVRFFrOVVicnh1U2FUbzFyTFNPcWdNSkptMlNE?=
 =?utf-8?B?Uk53NU80dUVWbENNVTJ4eDJvKzNaTnJYOE1LcTI2alF6Y3V3MHdWRm5MaHNM?=
 =?utf-8?B?YThDWlhIc1g2QXhsaU1kVnpnYVgxZjBvWU9CTHlhNU9KbWxHd0Qwc3EweWRk?=
 =?utf-8?B?cnlIMHVKV2hiR3RUemJQL045NnRWeWdqalhiMG16bFArM3VoKzJ6L2d6dEZQ?=
 =?utf-8?B?UTlrVUI1OUp3YjBpUDNqcG1PL2kzek9rR0dwL3BHbHVLb0Z3VEx4UFlwaUV4?=
 =?utf-8?B?MHBnTWtTRUFQSlIwWWppWGR0N3kvL1g4TUgyM2NESEI5aFJucE9IeHFwcmJp?=
 =?utf-8?B?Rk5mcGRmVVc2V1dNUmhKNnlCY01UT00yNGFnSHdFdjhxallOTDZPNGVKZExa?=
 =?utf-8?Q?+6YyHPOp47tn0G4KXo=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cf2cbc52-2783-4901-6b61-08db1ac2d649
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB3794.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2023 02:07:12.5732
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3Rouh7fG+KQeFHV3MmIDCagBDYzR3TUUhr1EtxLVPhJm980IqW40nEvpun2KWVj8D/Tu21KjQQTp722oBkqUSw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4284
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-01_17,2023-03-01_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999 mlxscore=0
 adultscore=0 bulkscore=0 malwarescore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2303020015
X-Proofpoint-GUID: IvuowklzsLRed5C-vXHc9T8HNKx6y4FI
X-Proofpoint-ORIG-GUID: IvuowklzsLRed5C-vXHc9T8HNKx6y4FI
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Build ID is missing for arm64 with CONFIG_MODVERSIONS=3Dy using ld >=3D 2.3=
6=0D
on 5.4, 5.10, and 5.15=0D
=0D
Backport Build ID fixes, which work-around ld behavior by=0D
modifying vmlinux linker script.=0D
=0D
This has been build tested this on {x86_64, arm64, riscv, powerpc, s390, sh=
}.=0D
=0D
Simple test case:=0D
  $ readelf -n vmlinux | grep "Build ID"=0D
=0D
Changes for v3:=0D
- per Greg, re-style backport of 84d5f77fc2ee ("x86, vmlinux.lds: Add RUNTI=
ME_DISCARD_EXIT to generic DISCARDS")=0D
- per Greg, add justification for backporting:=0D
  99cb0d917ffa ("arch: fix broken BuildID for arm64 and riscv")=0D
  which has "Fixes:" to v6.2 only content.=0D
- rebase to 5.4.233=0D
=0D
Changes for v2:=0D
- rebase 6/6 c1c551bebf92 ("sh: define RUNTIME_DISCARD_EXIT") from upstream=
=0D
=0D
Previous threads:=0D
[1] v2 https://lore.kernel.org/all/20230210-tsaeger-upstream-linux-stable-5=
-4-v2-0-a56d1e0f5e98@oracle.com/=0D
[2] v1 https://lore.kernel.org/all/cover.1674588616.git.tom.saeger@oracle.c=
om/=0D
[3] https://lore.kernel.org/all/3df32572ec7016e783d37e185f88495831671f5d.16=
71143628.git.tom.saeger@oracle.com/=0D
[4] https://lore.kernel.org/all/cover.1670358255.git.tom.saeger@oracle.com/=
=0D
=0D
Signed-off-by: Tom Saeger <tom.saeger@oracle.com>=0D
---=0D
H.J. Lu (1):=0D
      x86, vmlinux.lds: Add RUNTIME_DISCARD_EXIT to generic DISCARDS=0D
=0D
Masahiro Yamada (2):=0D
      arch: fix broken BuildID for arm64 and riscv=0D
      s390: define RUNTIME_DISCARD_EXIT to fix link error with GNU ld < 2.3=
6=0D
=0D
Michael Ellerman (2):=0D
      powerpc/vmlinux.lds: Define RUNTIME_DISCARD_EXIT=0D
      powerpc/vmlinux.lds: Don't discard .rela* for relocatable builds=0D
=0D
Tom Saeger (1):=0D
      sh: define RUNTIME_DISCARD_EXIT=0D
=0D
 arch/powerpc/kernel/vmlinux.lds.S |  6 +++++-=0D
 arch/s390/kernel/vmlinux.lds.S    |  2 ++=0D
 arch/sh/kernel/vmlinux.lds.S      |  1 +=0D
 arch/x86/kernel/vmlinux.lds.S     |  2 ++=0D
 include/asm-generic/vmlinux.lds.h | 16 ++++++++++++++--=0D
 5 files changed, 24 insertions(+), 3 deletions(-)=0D
---=0D
base-commit: 69f65d442efe5eb3c1ee8adec251b918c1b0090a=0D
change-id: 20230210-tsaeger-upstream-linux-stable-5-4-07f93e88c218=0D
=0D
Best regards,=0D
-- =0D
Tom Saeger <tom.saeger@oracle.com>=0D
=0D
