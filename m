Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F13AF644D69
	for <lists+stable@lfdr.de>; Tue,  6 Dec 2022 21:43:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229560AbiLFUnr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Dec 2022 15:43:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbiLFUnq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Dec 2022 15:43:46 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88F5543847
        for <stable@vger.kernel.org>; Tue,  6 Dec 2022 12:43:45 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2B6IxR8N012449;
        Tue, 6 Dec 2022 20:43:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2022-7-12;
 bh=gOgBBysPYheShDY/4Mjs/briDBNQcOYsStQ5RFRjxqY=;
 b=dV6SjDJfm++0frYv7S1B+3z73ot/tIMMJE79pYNuJzmLuonxRNvtk+efiboAE77BYP/Q
 pKem/03P8VsSD2Kqx8rCd8P6woPvmQpNql18wMnwPWFmp2O0nT8aymtbptrxNMD7psl1
 hWgiSROgpizVgiFoe9QmY+STtpGHsZnmz7bWyCneZt/DAeLvj0uAGNNaKWH6t2IwgUde
 POHyLnmgY4MGe8TssGaRaewf3Ba+Npp1oDls64IfxHxKgqyfCs/BVwVt1fCrZumuevFP
 6B+DS5WjzNcEAxQtB/9Hv8mzo57uyfl8D85njvhSJWMUqy7dabp+8DxcEp1XBIzyULsp eQ== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3m7ycf8udn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 06 Dec 2022 20:43:44 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2B6JETvd021789;
        Tue, 6 Dec 2022 20:43:42 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2177.outbound.protection.outlook.com [104.47.57.177])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3maa5wg6ya-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 06 Dec 2022 20:43:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oBL/RNhJcz8C1YAFyZ6NsNF+Uc5QH9N3jZZvX17EQFjtyj7jJOZv8v/7D2TRsv54UCCGAkpLRA33auwxQ+Dl8fZRznFJqamxf9uNcDNyXzqDUsBx12BIE8yZ7rBPvoRe/a+Iv8Ratq/iJG2se90QxmIXy2ZaBY+88aO3UxPtIBifsr5yBPQhy3chNoVSJenWEbEXuM7udow1wXWYWlYOiFlNhbinv8vQlGhIldp86PCtSIvIsZ7vLg00hE/U+/r+DAiD1kJCFbItGEkEu1M+qBxQ8tcuC5YfnO9+fD91Jmgjep003VIRo5yANlEGw3J6UqkoT7wtw6TMoBCw6Qu+/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gOgBBysPYheShDY/4Mjs/briDBNQcOYsStQ5RFRjxqY=;
 b=IpdDlIljXEz1lJPb3StnwAuMoi/2yvc4cA9tD5Kd2Lsj3mfqz0++PEiaq8RThNNeU3JZQL99GOLwwXOZdxAoB6kzAHQhNrvXSAzifnH5mQl9qv8kSVbkb6wNhYqjrUpxyLmrn99EpcRHiU/clBaqjclGevVivd6X1H0I1DAqWo52VfXnutgH6IyZ+MIRsUwO6CUNABpzoUpyLI3gHN1QoXqRtLanKRImYIfl87hdxTs78LVKFJrvjoplI7pJ0oH2nrvP/fhk05VyKlvBdgdMttFkDSNy2z3S/GPZv6C7OPCAATGRxJG61KRAm6qiXfKe3pTcj3xGXOChzqmsRnn60w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gOgBBysPYheShDY/4Mjs/briDBNQcOYsStQ5RFRjxqY=;
 b=gElECYvcnJc7MUlfE4TBx5WUipY2laFehPWaV31/yHBvQL9uwAxwfAfr9E+ePOTT3sYbvvbsw4Ve/t2B7Ftwb5tHkvcHrHeXWmVak7s5UfjOAPLQFWdemOJIsE0p8dWnk48NM1oE4qPniA0zusom8BNeYbWkbjD2gXC784aaOBw=
Received: from BY5PR10MB3794.namprd10.prod.outlook.com (2603:10b6:a03:1b2::30)
 by CH0PR10MB5178.namprd10.prod.outlook.com (2603:10b6:610:dd::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Tue, 6 Dec
 2022 20:43:18 +0000
Received: from BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::cf51:e63a:8137:aae0]) by BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::cf51:e63a:8137:aae0%6]) with mapi id 15.20.5880.014; Tue, 6 Dec 2022
 20:43:18 +0000
From:   Tom Saeger <tom.saeger@oracle.com>
To:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 5.15 5.10 5.4 0/1] arm64: fix Build ID if CONFIG_MODVERSIONS
Date:   Tue,  6 Dec 2022 13:43:07 -0700
Message-Id: <cover.1670358255.git.tom.saeger@oracle.com>
X-Mailer: git-send-email 2.38.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0291.namprd03.prod.outlook.com
 (2603:10b6:a03:39e::26) To BY5PR10MB3794.namprd10.prod.outlook.com
 (2603:10b6:a03:1b2::30)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB3794:EE_|CH0PR10MB5178:EE_
X-MS-Office365-Filtering-Correlation-Id: 121c8431-aa44-42b8-ec9f-08dad7ca812a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5LtiQvm3x7+2MgchoNY6IBTO4P8REyV3/Rhiar3oWcNqjHaC8q3Hi9WZP8YGgqLJAqdhIkvsxSRwyCYc9iq14atkAK9IC86q/nGrqOg74wiPJPFXJ64teYwKrFnruhaPROs6GtYKVFJr6xIpK77qk7zgNlUxjgy2E2y2MFuxZXejUIEG9ORsloaZNVpVi1UkGHHrAJRGnOdW6XKjmvAh/jkG7Jaiht7CCd6QnEKUvJ15dUwVKfrhiXOAhWxQgjW4Veot5S0NEZi+F7IM8uR8XaZfbBFKVc1odZu9VTDootulO4jieLQJjnZ2htPe576QAPUta/Zkvqz0wBwTweJJWnjoAYSvG4iJRyPMR5IQ2pAz7il4CIpTFsO6O6cue/DM3jRN/41FP33osF4HRzojDKl+Blb/prBwVCPLDpSlD9cUeNVUV99L7ISV4SI3ToIdvwu3zhhmS30vjhmIGHNlXpyAoSsGpSBAmANWCd1X6M9eMGx4dKiVtvKmPTzCwo44+7od6kCIeXXIP8spJeTwswBDErZrabwyTKClIzI57IyD/FG4/EocuXYYexGHSod/8hHcCItqLtBzVKmdTJzoIYXWAkfpq4f3cQMFwIEERHDwPMxPK9AFNv4SecBiifaYH+YQdqfxKvXRZUDNr+pdhg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB3794.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(396003)(376002)(39860400002)(366004)(346002)(451199015)(38100700002)(86362001)(8936002)(44832011)(41300700001)(66556008)(2906002)(66476007)(66946007)(8676002)(478600001)(5660300002)(6506007)(6512007)(186003)(6666004)(316002)(2616005)(6916009)(6486002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?U0U7tVmyH0HbSxAiQ2wRaY72xOftnzx7AK+AIQ1+B3cqOJ2zn9lTahgp0lMz?=
 =?us-ascii?Q?xQBhUOP37M9kD/VMhERxWctBXUkk1B8Vs4IDzR9LYGpkFWTmWJmd9mC0WCc0?=
 =?us-ascii?Q?HJUfwt8IWluxZlH7LTNrwlEs9pRPHYdwR0wlCcDorzWk0LNNShA/0scRIyMB?=
 =?us-ascii?Q?n6I+GEVYIsjxxyIUqfYDmFj7JwUwbtnXRQkncfIWlNZouyao/A11QrwkSc3Y?=
 =?us-ascii?Q?gBquRVwCGOp13R2UIytnEPjIsOVFnxnAhXcYmOhDNj19RCdFECh+YwdguhA/?=
 =?us-ascii?Q?+lP8hAE6VtcMAWk3UZUMcTXf5VCr2D8xuK2eASgHMC1dF8vrdgQ57NZc26MK?=
 =?us-ascii?Q?etXdKw3F0LRW1B0GyZ8dN1vcXOSxq7uKSH+Q87auy4fIVHEsjwDEz/dtGDX+?=
 =?us-ascii?Q?qmFOPA0k58HI1q0SHPzv6qsj5mryx+YXVtz/mrnYFOAB/wx4zWm03Synsk0D?=
 =?us-ascii?Q?EQxHJVV1aq/tecSqEGEeDlc+q/9oV3wfNFtNSGyU2vxoyZ/Sclgifk40vFEi?=
 =?us-ascii?Q?5u1hNL4a1MU/Imk20TuvbgdcLa/eoYKmAdg3snAYoKqvkRRoTumzYEk+c+4B?=
 =?us-ascii?Q?uFXg3mrnzaVJd4EepwI0ZdRIv5JghJ6kEmILlKDtMCLAncP9iC0ea/5U//uf?=
 =?us-ascii?Q?mZnoq6UMbtcaTQJiyQDclWAv+aMQt90LroCaCAuZMwm58KQm/94eVpWFFrGE?=
 =?us-ascii?Q?zVlqydMvbY6ChcL3x7kX1XAHliQ8nJxtZ7UH4VUZqR2TI3AX6rQY3jluzyF1?=
 =?us-ascii?Q?eboeWBbqFofPJuUWy/1cOG8uhpno73TcOx+IqA2ppEf69cyxtekVHyHJqU4v?=
 =?us-ascii?Q?TC3LRFNAdhzXDjnCeRcQlKP0nfXA7hWJOc8D4pCGpIhPwIPGvj3tibnjcE6D?=
 =?us-ascii?Q?1h4Sq0Byl7AOVmiB1foEHRZlV2rqrdkyHSHfP7Tv+nl7fbMWv0wYckBChV/z?=
 =?us-ascii?Q?YU07z6s1RW7T+/vqgA4oyqG3p9XDnwFhjw3d4LJLEeutbzmfHRaT/VhIIKoL?=
 =?us-ascii?Q?lIN/7NSjX/rK2upBz4bkASp6mgLhJcyo9ryU+eh3yb6Naiv+jILyHez3bbc9?=
 =?us-ascii?Q?Vwd2yQYwh8XWiy9dXdazdbaM/d6Zr0+IlkLW0APW7cz2HF8n5BPpv/T8/76A?=
 =?us-ascii?Q?+q9dRO0YJiyN6FjhUSsf7sIgpA3g5SwCFSH+9berR8U+HEwGlTm0CRsfP3S5?=
 =?us-ascii?Q?gdQa63strK/dw8+ko0sd4DaKkIO4QY17GcNU4tby80jtipJpFcA0hdugLdv9?=
 =?us-ascii?Q?C9e7RYCJ0qSRn0rv+dLQ/ozcBrCUoNSUyF/8YJz8lNgDCcpW4IcEW5CO4QhE?=
 =?us-ascii?Q?7D56BJ+SIjTUaeao5U0p0f6xDndgmJ0t7AvnXuyjtJ6u8u9/kOGH7QaKSyB6?=
 =?us-ascii?Q?apTUeM6rBPnOlSHlIBCvCj2ASojdWcx9r2oVYfggm3lJvgtP4x/1QtWEKgMH?=
 =?us-ascii?Q?A8eAuJPBuUxZ55nw6LmyDDdaxoz4wI7Ki2XEir0T5M/WkB+AV6B6i5cqgdeH?=
 =?us-ascii?Q?BWVl8z0vHnJTm1ocJVnM0WpG5V1YxLuhqfK5TJ3LwfuMn9iPLce9vxBkBW+4?=
 =?us-ascii?Q?Ikms8qCGZks8NlhFswmurW0uqBgy9hpKLUDdoGSFbDIzPbXWf0O4kUa1tl1H?=
 =?us-ascii?Q?Pg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: qrk17GYRjbxlBxZC0fVr4EjVuBZWAJ/FHsY2LYPB+wD5/dBMQqR3MapNUdF47p5NRfb42unTWdOLUcl3wm2MTlDb2KRkM/mH4f6JxUbgSO4mdTAgpav/9fNqoZTUDITTsJi7sHBwI3AxZ/aSXIcymaetNWTVS/N78uB8EfPjs3HHom0kX6dLjNUMDJtC8CkbYGvnFYi2tpvGdv6p96r6nL6QVKeMUsOCk1ItRwSFEA/r5jddS3bOZEkGAvWb+DWJUZr+XpRSXFQzBom93P0UK8vB4Qg7Gqr0hYbLeZDxmyZbTVr833xY5UuqkLAOmSRfNCf2LjmlUQ7g+15ayiCaTbka5smpnf9pncW0WVsk4t44RKZSUI7ye1CrzyFvIVgHAA2MIg724254iztWmhcBYIOF/0XsXuxr2cQEE2Hp4FUJBlDBPqLAe2R83j7u5GWuEwFjVBRcL5Y8R+jDtakVC4ADjpKT6YmroLxcuy1s6m1WlnILxMwloPcUDsNgGJu6KyyROLz/RSMQAkPof116UYaDSuV782kIV7VBIwFPcal4BpAkEYWREt/rUx/GPx/SHFyvK9eFkpPrZlFSwNyy+lax+3Khikdx4KQ32KW1V2XB2dh7OI7Piz8KRFGfCZNCcmOzJ+Q0S+Mj90SO7DGeDaD10wPhSUGRkDNil/A1CXsDT/K30fUgX1OoUNDpl3mjG2QDEAZkIpsw1md51XSzaR02R1NrpAWvd97kGOIPSftTV4GxV5GFoSt7AkRUb63IYbfZ6m6PHiZN94MWrWs6IoRaqXUa7+NzRkXXm7J+ec2+1BEjVqO+PdCrpp0br5pc
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 121c8431-aa44-42b8-ec9f-08dad7ca812a
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB3794.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2022 20:43:17.9129
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WzPK6dj/yfnV6n9x9tIqoEBqUPZJm35lkUsv0iCApoBY16CDHDOjSdVVxakZY1RfrxArqc/Yfe7z0dZ9KJVNUg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5178
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-06_11,2022-12-06_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 phishscore=0 spamscore=0 bulkscore=0 mlxscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2212060174
X-Proofpoint-ORIG-GUID: Z0M4Pn3GVkH1FCRySmHCwPNDX_121wpP
X-Proofpoint-GUID: Z0M4Pn3GVkH1FCRySmHCwPNDX_121wpP
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,
    Our internal rpm build for aarch64 started failing after merging
v5.15.60.  The build actually succeeds, but packaging failed due to tools
which extract the Build ID from vmlinux.


Expected:
readelf -n vmlinux

Displaying notes found in: .notes
  Owner                Data size  Description
  GNU                  0x00000014 NT_GNU_BUILD_ID (unique build ID bitstring)
    Build ID: ae5803ded69a15fb0a75905ec226a76cc1823d22
  Linux                0x00000004 func
   description data: 00 00 00 00
  Linux                0x00000001 OPEN
   description data: 00

Actual (post v5.15.60 merge):
readelf -n vmlinux
<no output>


Digging deeper...

Expected:
readelf --headers vmlinux | sed -ne '/Program Header/,$p'
Program Headers:
  Type           Offset             VirtAddr           PhysAddr
                 FileSiz            MemSiz              Flags  Align
  LOAD           0x0000000000010000 0xffff800008000000 0xffff800008000000
                 0x0000000002012a00 0x000000000208f724  RWE    0x10000
  NOTE           0x0000000001705948 0xffff8000096f5948 0xffff8000096f5948
                 0x0000000000000054 0x0000000000000054  R      0x4
  GNU_STACK      0x0000000000000000 0x0000000000000000 0x0000000000000000
                 0x0000000000000000 0x0000000000000000  RW     0x10

 Section to Segment mapping:
  Segment Sections...
   00     .head.text .text .got.plt .rodata .pci_fixup __ksymtab __ksymtab_gpl __kcrctab __kcrctab_gpl __ksymtab_strings __param __modver __ex_table .notes .hyp.rodata .init.text .exit.text .altinstructions .init.data .data..percpu .hyp.data..percpu .hyp.reloc .rela.dyn .data __bug_table .mmuoff.data.write .mmuoff.data.read .pecoff_edata_padding .bss
   01     .notes
   02

Actual:
readelf --headers vmlinux | sed -ne '/Program Header/,$p'
Program Headers:
  Type           Offset             VirtAddr           PhysAddr
                 FileSiz            MemSiz              Flags  Align
  LOAD           0x0000000000010000 0xffff800008000000 0xffff800008000000
                 0x0000000002012a00 0x000000000208f724  RWE    0x10000
  GNU_STACK      0x0000000000000000 0x0000000000000000 0x0000000000000000
                 0x0000000000000000 0x0000000000000000  RW     0x10

 Section to Segment mapping:
  Segment Sections...
   00     .head.text .text .got.plt .rodata .pci_fixup __ksymtab __ksymtab_gpl __kcrctab __kcrctab_gpl __ksymtab_strings __param __modver __ex_table .notes .hyp.rodata .init.text .exit.text .altinstructions .init.data .data..percpu .hyp.data..percpu .hyp.reloc .rela.dyn .data __bug_table .mmuoff.data.write .mmuoff.data.read .pecoff_edata_padding .bss
   01

readelf -n fails since NOTE segment is missing from vmlinux.

Why?

5.15 Commit: 4c7ee827da2c ("Makefile: link with -z noexecstack --no-warn-rwx-segments")
surfaced this issue.

1. Reverting this patch fixed this issue.

2. Removing all .note.GNU-stack sections in cmd_modversions_S also worked:

diff --git a/scripts/Makefile.build b/scripts/Makefile.build
index 17aa8ef2d52a..b95cfbb43cee 100644
--- a/scripts/Makefile.build
+++ b/scripts/Makefile.build
@@ -379,6 +379,8 @@ cmd_modversions_S =								\
 	if $(OBJDUMP) -h $@ | grep -q __ksymtab; then				\
 		$(call cmd_gensymtypes_S,$(KBUILD_SYMTYPES),$(@:.o=.symtypes))	\
 		    > $(@D)/.tmp_$(@F:.o=.ver);					\
+		echo "SECTIONS { /DISCARD/ : { *(.note.GNU-stack) }}"		\
+		>> $(@D)/.tmp_$(@F:.o=.ver); 					\
 										\
 		$(LD) $(KBUILD_LDFLAGS) -r -o $(@D)/.tmp_$(@F) $@ 		\
 			-T $(@D)/.tmp_$(@F:.o=.ver);				\

3. But the simplest fix I found was to remove -z noexecstack just for
head.S (this patch).


This issue exists, in my testing of arm64 builds, for stable versions
5.15.30+, 5.10.136+, and 5.4.210+
and reproduces with every attempted combination of gcc{11,12}
ld{2.36,2.37,2.38,2.39}.

It can also be reproduced upstream by cherry-picking 0d362be5b142 on-top until
7b4537199a4a ("kbuild: link symbol CRCs at final link, removing CONFIG_MODULE_REL_CRCS")
which was part of merge
df202b452fe6 ("Merge tag 'kbuild-v5.19' of git://git.kernel.org/pub/scm/linux/kernel/git/masahiroy/linux-kbuild")

It seems kernels prior to v5.4 and 5.19+ use differing KBUILD rules
(with CONFIG_MODVERSIONS=y) for linking components of vmlinux, and in my
testing these other versions did not encounter this issue.

Other architectures besides arm64 might also have similar bug/feature of ld.
Though, x86_64 v5.15.60 worked as expected, so no further experiments
were performed for x86_64.

arm64 repro test:

make ARCH=arm64 mrproper
cp arch/arm64/configs/defconfig ".config"
scripts/config -e MODVERSIONS
make ARCH=arm64 olddefconfig
make ARCH=arm64 -j16 vmlinux
readelf -n vmlinux | grep -F "Build ID:"

Please consider applying for 5.15, 5.10, and 5.4.


Regards,

--Tom

Tom Saeger (1):
  arm64: fix Build ID if CONFIG_MODVERSIONS

 arch/arm64/kernel/Makefile | 5 +++++
 1 file changed, 5 insertions(+)


base-commit: e4a7232c917cd1b56d5b4fa9d7a23e3eabfecba0
-- 
2.38.1

