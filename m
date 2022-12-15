Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0D8A64E49B
	for <lists+stable@lfdr.de>; Fri, 16 Dec 2022 00:19:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229680AbiLOXTQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Dec 2022 18:19:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230032AbiLOXTC (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Dec 2022 18:19:02 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89FA15C777;
        Thu, 15 Dec 2022 15:19:01 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BFL4WqR017507;
        Thu, 15 Dec 2022 23:18:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2022-7-12;
 bh=aw3lSYEa2/YUm9sTuwoRisjhJCBhthxxGfalQlOAveY=;
 b=Etzo0KcY7hm4DNWcwi+NyXE6cbbr3QmcTF3Sj/DAbQ449L2gEnadCWvsruah6o8OJqzp
 NatUzIaRKpXgRL1nS+PXQ0m4HdEQuMPc5+HhAor9cS66w/c1fNOhV3F163U+vsU+z0Zw
 NajJhpk89dNB5OPyMiDi7q7nQBBZo/ZFxFS4iN/jqSO8Nf+XzzrVxg8d2hMEYCZDRxk6
 ODnI7VeM6ljKAvhvh1+7hpEeElfXi/3t/1nwPr665nurS/6xkGLHxRCIEdMb/F4PfWfi
 +ne8HAzRMwSqy+EFQI5Vk54isQ29oRO53nqYB2cQnXaRZWEvFAW6tjJFD8OidqWsI5Oe /w== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3meyewxdyw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Dec 2022 23:18:40 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2BFMr7ML011059;
        Thu, 15 Dec 2022 23:18:38 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2045.outbound.protection.outlook.com [104.47.73.45])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3meyewj06d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Dec 2022 23:18:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HfJl3t/9CNxtL4NdOZBFTQI6im5/5xk7G5PvAMQ/7k6Pu0uUyjvrrgCCJonlckIWRzyj9IxsLm8uFWl84BXQNNVkgIpwq8GhZx7HZV9h5BVVjfKFOduUcktKf6bg2DIxaWjxhVaMq6w4G80Ro5NdxTHMdVcuNlc/Het5oTGlU8zXZ03Sz3osVzK5id49kJz5uTzaMsQ2jHXX+BQbm1IxwH6NXqc6XTDFLkROHTweOQjdbdxo24o75ayTs8qSUa9iNcw6mbgkOMmnqvjMsI9HVNSKsQxoBLk7F43hXz13P2LvRrg04LqhpmnKvXvdbquIYhyo8RGh6yc37i6Jaxwi4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aw3lSYEa2/YUm9sTuwoRisjhJCBhthxxGfalQlOAveY=;
 b=CfFbyfpM78Jb+jD+arUBsD7QHvkfPatrcSqYl09YRJuoNmLCmMCGKJpAc9yNv8UFUh968pa4rJo/eTfk5JQO9e/2b59Qn7xdKSzLd0zRKrrr/7wcOoml1UowOJSESn+O0WD6g33eVKfRYkEH4ejOnaOUpiT8d7plJlhLWQmE3j93DndEXIr7rCa0X4S2NuZtCmTrUO1e9a5NaFdyHP85qHfB4wvz+r7cSSfyGGBEStUYo94JEFrRxxDnw6JnciGjfsvjxCo6ZQm1AEXr/1ygLZ/5a5xzUL4mkCWJj9eoomHGzFrftdrkZMKh4BealNfxlrVNWMwdeW8gyc0Ijduc2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aw3lSYEa2/YUm9sTuwoRisjhJCBhthxxGfalQlOAveY=;
 b=EGCZ4a7HJUgzsXiBZSeF9eVBoHrb/GuPIrZzdq2YYvC4AirHVqyjgoFcmgaT/2NIIoYwhQ5r7B0sEHN3opnfgr6GcZ17NXqTbhwMfK8bZXvW3F48MIE3w7kPezXr1G8FWcwLC5LmeDGOS2wg369JDTtZeBkhSOxjen4CBNaXgTA=
Received: from BY5PR10MB3794.namprd10.prod.outlook.com (2603:10b6:a03:1b2::30)
 by MW4PR10MB5678.namprd10.prod.outlook.com (2603:10b6:303:18c::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.12; Thu, 15 Dec
 2022 23:18:36 +0000
Received: from BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::cf51:e63a:8137:aae0]) by BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::cf51:e63a:8137:aae0%6]) with mapi id 15.20.5880.019; Thu, 15 Dec 2022
 23:18:36 +0000
From:   Tom Saeger <tom.saeger@oracle.com>
To:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Tom Saeger <tom.saeger@oracle.com>, linux-kbuild@vger.kernel.org,
        Nick Desaulniers <ndesaulniers@google.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Nicholas Piggin <npiggin@gmail.com>,
        Michal Marek <michal.lkml@markovi.net>,
        Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH 5.15 5.10 5.4 v2] kbuild: fix Build ID if CONFIG_MODVERSIONS
Date:   Thu, 15 Dec 2022 16:18:18 -0700
Message-Id: <3df32572ec7016e783d37e185f88495831671f5d.1671143628.git.tom.saeger@oracle.com>
X-Mailer: git-send-email 2.38.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM5PR07CA0056.namprd07.prod.outlook.com
 (2603:10b6:4:ad::21) To BY5PR10MB3794.namprd10.prod.outlook.com
 (2603:10b6:a03:1b2::30)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB3794:EE_|MW4PR10MB5678:EE_
X-MS-Office365-Filtering-Correlation-Id: 32d79bdd-ee37-468a-8dfc-08dadef2b0f6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aLPXrxluXpQO6xqstBgO/h7CX5B9dNIFr2ivJ5sYZ9MES7b3bPUri8bRM/D6Rv25n1tmOL2LkuDIZ2uePX3N3wZbO6bA+EJ4Gk0iZLPjB/FrnGxW/4RJfJChAXiI7g5fqPTQGK3k+dIY3hwkeiSQuJut7dMJ2NZtrehMstEZVbqXhqM1qX3S/pS4mMmKebffOo2myQMYE15Cpjq4ElHCQpAQ+Z46Ml/XCIC2q5ROUE8xJlMzDbb43GBktvReI3ZS7rwKh6n1VTyEkJSt7qOPouxY9OcZphwpfV/zf7PTUQ0WV05kxE7MXcFb7yhSv1LRK+wucZpKchv7aK+ZIn20AkDWDJ56C72ma7a8XuH8ZCNTtk8UMJ3cdJ40dtzvGZfrWIOJNoHuoZSHFANj/NWEpgbhmkfTPn9ezrCbi+wDghpK5zmGP0HqC/eac/FBvWbd/3KmEXHiWVhjvNJ6g6KBBcIVNgaxq3UadSB1Z5Fb4tGeoo3nbkwJtXZw202bF+UcBm5SbONJ3ZSpiXPuQAM02gPLRjCif40LDGKfW4Kl5n+y2AJJqJdBlAiEivF11yMWrTNyZ7tfFJagOjjfLQSbg6HawsZYBdrsppwEymwwL7dxknNiUf6FWyaJB1iX805xZGappkwSFN6s4/Hr1WkYjKbPaLiUt0yDf+LeSNNI4gE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB3794.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(396003)(376002)(39860400002)(136003)(366004)(451199015)(6512007)(6506007)(2616005)(36756003)(83380400001)(6666004)(186003)(966005)(6486002)(478600001)(8936002)(41300700001)(38100700002)(316002)(2906002)(54906003)(6916009)(66946007)(8676002)(4326008)(66476007)(86362001)(5660300002)(66556008)(44832011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?BPYvoArFkOayY24sricFQDDNry5MP7owyYsE1oHDon3CEYElBaMDo5y6+HVM?=
 =?us-ascii?Q?1qGQekGzMQMCU59QniLRCVnIqIQnZqGDDZYcYJw7WRa1zOjq9lPVZRSuhjuD?=
 =?us-ascii?Q?ytMhFKkIlGpR+BhOMGb+YDDXARWdJnkhlN+OtrGyBnqcjn7eGxwEtyJWHq0T?=
 =?us-ascii?Q?Kr97Q9zOmYVDvozCuGEHrmkjs1qXp7rRbSYXI0NLwUlrDzUIFq2Rp4eJh+7o?=
 =?us-ascii?Q?4V9y6C74El37OszZMy4vUnrAW/rx8bE8Z05Wr4vmvC3DV/ujQkRrxRHbueG+?=
 =?us-ascii?Q?z3WV9bfDYAoJrONe3rC7pWypNhOh4T4LQx80n/cjoQuxFXbJ+9hssXrz9LdV?=
 =?us-ascii?Q?ravSzKhSqVSNOLky2aWoSY5oYQIUfCJsQN3TzxZtgBEjbIj8C1E+S/4zPcL/?=
 =?us-ascii?Q?MHNKOXPq2qV1whQaFKpovFbuWKcn83i6BYKMOEkBhat8QgUWWhctqnlh/fpJ?=
 =?us-ascii?Q?/fl/Kd9BR+Mgm3B/u+p8yFI9lIunB4xuXy3YwjeKLuFL5HpYK5gwBSMZeHln?=
 =?us-ascii?Q?pkkQbuv2qoATA/G2thwUGGeEEol30lmo+wqXo2xOKJtm8PfhvNUuOdD/u48K?=
 =?us-ascii?Q?KV0Wae7tCb473TcndzGjlCOLO3TxCPpkODroMPJijj/S7L+bbbuVTJY4e49E?=
 =?us-ascii?Q?EHJSHhLD28wgivSpOd0jixvi9v7/HbyddPszpx57eIFg4SXqMMOb84dHSbrt?=
 =?us-ascii?Q?BZ1/rHRyWDYelWP9lSJCSqgqevrBNqI3BNAueM2bMrwmK/mxYgqMjBXW5DXH?=
 =?us-ascii?Q?/md/lewmakJpA2M7mY11lkz6y/jPBc14rkV43WUK4aRRvY+il8s54Guxt1ci?=
 =?us-ascii?Q?TOSQeTa+KRlARhqLTB1f9/2ytAmaPz1isIJoDQMcbD+Ugwxv9GrVBCaJh9z9?=
 =?us-ascii?Q?nsFnhH46mUoiAw0Qcg3Z8aZgltSk8hia7buFG5yZ+HbXr2TSkdRaY+tz76ci?=
 =?us-ascii?Q?j+yAlN2fh+Jq+LaDGC+Tzttxbw4iJaw+pnZt03z18fz7xJpyYmRG5peoHxIO?=
 =?us-ascii?Q?GkrPEozrjAspK870wC4Lu3b3InFj8RgGKVUPnG63iROwvrpDIqoMdnGxwiLj?=
 =?us-ascii?Q?kLT1G4HqXI0SqSq1bYVbn/nfn4Ks/h965On6+jztksSNvJzGP3kqrpsIIFmX?=
 =?us-ascii?Q?QNOACdBcN9fOpR3AopiNy9IyfFvC/HC3hsoJpa/XvOg6DB/gzRfEoMwj05ya?=
 =?us-ascii?Q?PFysnsDBxahFFK+XUOPR+fUsTNnI6Iv1vtj1RerkE0jph/46nJqblAOcijm9?=
 =?us-ascii?Q?baGow9y3wkmDNJPk8Nn7ETzNMyewCjVav8UzFEBbn+eS1NOMv/3KKrIfler/?=
 =?us-ascii?Q?RdZVTejmgJCOs6zEVs0WWdTLGcAG8fWVuxdT/098y8rlhcu+Do55gkzIAI9i?=
 =?us-ascii?Q?zfHWX/x/b9N3idENzvDk1vg+lPjA+zp7laHYJVwNdymUrbYi/FU+qQBP+z1m?=
 =?us-ascii?Q?M32+12UADF8dIApSF3jjfMcdiKoS15LqBNUSEN+6UPlI+CVwM3XazE34e0WY?=
 =?us-ascii?Q?2le3NPr0TBNqLiShFr1Y6+pDko9Jal9Ym40mWItpO/HHd/MKuLeFKmj2f5Tn?=
 =?us-ascii?Q?3riANOKLypkFxQCFzca6TmRZDr2tgc48PaRnuafPvM7ISfpQRKxzldZ3CIkW?=
 =?us-ascii?Q?gw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 32d79bdd-ee37-468a-8dfc-08dadef2b0f6
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB3794.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Dec 2022 23:18:36.0465
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: E/MYmRKT7w9Z+Dl0TzH6POsxBklD2b0lkDjTRkfX4berK3/1dLWfdqmq1cpNalj2fvGDmqKj8zLAoKJfh0laxQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB5678
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-15_11,2022-12-15_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 spamscore=0
 mlxlogscore=999 bulkscore=0 phishscore=0 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2212150193
X-Proofpoint-GUID: NyDfbgPCJoK80rI1YayYtVPxKF03CcXm
X-Proofpoint-ORIG-GUID: NyDfbgPCJoK80rI1YayYtVPxKF03CcXm
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HEXHASH_WORD,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Backport of:
commit 0d362be5b142 ("Makefile: link with -z noexecstack --no-warn-rwx-segments")
breaks arm64 Build ID when CONFIG_MODVERSIONS=y for all kernels
from: commit e4484a495586 ("Merge tag 'kbuild-fixes-v5.0' of git://git.kernel.org/pub/scm/linux/kernel/git/masahiroy/linux-kbuild")
until: commit df202b452fe6 ("Merge tag 'kbuild-v5.19' of git://git.kernel.org/pub/scm/linux/kernel/git/masahiroy/linux-kbuild")

Linus's tree doesn't have this issue since 0d362be5b142 was merged
after df202b452fe6 which included:
commit 7b4537199a4a ("kbuild: link symbol CRCs at final link, removing CONFIG_MODULE_REL_CRCS")

This kernel's KBUILD CONFIG_MODVERSIONS tooling compiles and links .S targets
with relocatable (-r) and now (-z noexecstack)
which results in ld adding a .note.GNU-stack section to .o files.
Final linking of vmlinux should add a .NOTES segment containing the
Build ID, but does NOT (on some architectures like arm64) if a
.note.GNU-stack section is found in .o's supplied during link
of vmlinux.

DISCARD .note.GNU-stack sections of .S targets.  Final link of
vmlinux then properly adds .NOTES segment containing Build ID that can
be read using tools like 'readelf -n'.

Fixes: 0d362be5b142 ("Makefile: link with -z noexecstack --no-warn-rwx-segments")
Cc: <stable@vger.kernel.org> # 5.15, 5.10, 5.4
Cc: <linux-kbuild@vger.kernel.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Michal Marek <michal.lkml@markovi.net>
Cc: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Tom Saeger <tom.saeger@oracle.com>
---

v2:
  - Changed approach to append DISCARD section to generated linker script.
    - ld no longer emits warning (which was intent of 0d362b35b142) this
      addresses Nick's v1 feedback.
    - this is applied to all arches, not just arm64
  - added commit refs and notes why this doesn't occur in Linus's tree
    to address Greg's v1 feedback.
  - added Fixes: 0d362b35b142 requested by Nick
  - added note to changelog for 7b4537199a4a requested by Nick
  - build tested on arm64 and x86
   
   version           works(vmlinux contains Build ID)
   v4.14.302         x86, arm64
   v4.14.302.patched x86, arm64
   v4.19.269         x86, arm64
   v4.19.269.patched x86, arm64
   v5.4.227          x86
   v5.4.227.patched  x86, arm64
   v5.10.159         x86
   v5.10.159.patched x86, arm64
   v5.15.83          x86
   v5.15.83.patched  x86, arm64

v1: https://lore.kernel.org/all/cover.1670358255.git.tom.saeger@oracle.com/


 scripts/Makefile.build | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/scripts/Makefile.build b/scripts/Makefile.build
index 17aa8ef2d52a..e3939676eeb5 100644
--- a/scripts/Makefile.build
+++ b/scripts/Makefile.build
@@ -379,6 +379,8 @@ cmd_modversions_S =								\
 	if $(OBJDUMP) -h $@ | grep -q __ksymtab; then				\
 		$(call cmd_gensymtypes_S,$(KBUILD_SYMTYPES),$(@:.o=.symtypes))	\
 		    > $(@D)/.tmp_$(@F:.o=.ver);					\
+		echo "SECTIONS { /DISCARD/ : { *(.note.GNU-stack) } }"		\
+		>> $(@D)/.tmp_$(@F:.o=.ver); 					\
 										\
 		$(LD) $(KBUILD_LDFLAGS) -r -o $(@D)/.tmp_$(@F) $@ 		\
 			-T $(@D)/.tmp_$(@F:.o=.ver);				\

base-commit: fd6d66840b4269da4e90e1ea807ae3197433bc66
-- 
2.38.1

