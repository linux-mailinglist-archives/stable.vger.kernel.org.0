Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FCE46AD3C2
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 02:17:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229586AbjCGBRX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Mar 2023 20:17:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229680AbjCGBRV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Mar 2023 20:17:21 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30DE44DBE7
        for <stable@vger.kernel.org>; Mon,  6 Mar 2023 17:17:20 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 326NwhJ2026366;
        Tue, 7 Mar 2023 01:16:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2022-7-12;
 bh=WkHLWwc4fpajzlZG0rmnhwoWnGxIEJONRXhpqrAT7vs=;
 b=xl/a3Lh7vXyISYP+WqvVpX71sjPI29Vg+HXFUohIOKJHreeJxIcEP12R7YgE+tkx24gZ
 wkkCaSzabAfistP8SJvnsR6uD9DTlDjUPX0kS0Sb5wj0OpkmDyeC/uNWcaTM9LbDmDj2
 muYomQHU2KuJn9XFscKii/7z1czWbJqpmgpdyRZghzbr1Y2mGPpFGipuYge8OBXwE4M/
 w4q1eG1cAxYmP+UWBXQSWZ8mMHFPxdxLASHkLvuNyqsmjSj1V7W863X3j6U/du5RakJ4
 d/h3ByOIWP5naJQe5OWX/KfNuvTPTQSBxHaIlvBKzE02241b8Mk5pNgPlpcieTkPcZ9j Eg== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3p4180vb3v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Mar 2023 01:16:40 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 326NZBsI025195;
        Tue, 7 Mar 2023 01:16:39 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2049.outbound.protection.outlook.com [104.47.56.49])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3p4ttj9tdp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Mar 2023 01:16:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dilNXHgf3AvA6FVjf9A76AHXjJGdFaSBe2PcReE+gxAFw0MgmNDW/T7/wqaXPXkznIcxHlZPAHKSuMZYJEyqQOyW5/L98+2dIRu80whel6qqbnlLeur3Le+yWK3pmE0ccLgF0YadDQvSE8xfP7/DCjBdy6SaGrQNX7VwZabid+sbm68nu1YmRwABJvH7C5pb4aZgjVdw29WbZahXO9FQwpvdY5twqPk/CadoY7eqLzZ76k+vpVFY5fcSBhF+SbMKAilsyIf8H255U8ljd0xEDHZLVd3jCjIq7Idci7zGqE5s1Wy6GfGFiXhIfFFgb63Hd4aMxxqLdiUv+s7+lJCOXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WkHLWwc4fpajzlZG0rmnhwoWnGxIEJONRXhpqrAT7vs=;
 b=jO0StWmofJ5UP5pryFi4wr/n38Ebm3b41Aw+Lt8RgUU4wSfhTFsv2ISzLavz3gIJP1ijrBVO/IKmFqwK/Cnyuf85zfZoZrywC3UheYZSoAEmI7lHMxAfsJ9hlMWcQkpvnV86jXb4ZbLINvcVZ+XXSq1oXe6PDFlGomR1awZjzAkQIhbkK93xurj1td65ze5snfYNoWDuHVSwcztq9Y91RyA5eSTVFVH0b/9Pb44SWjN1wOWp77wGvXsUpaP5fsuJ2NIOoG8JvHHgaztJ63V4/Pv4ri63Tchabk8Fl0T2a/V6dvKeWYyvFX2iasSrVS7UfmlQrv/IA9ux4EflSZhd3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WkHLWwc4fpajzlZG0rmnhwoWnGxIEJONRXhpqrAT7vs=;
 b=a6lrvoDBxaZF4LVXJsOD8JXfkDAE9osZMzLpFsN6I+IkdBrmrNxA2xlIvaKwF7LxzeIhiMwFizHgsPxhUcBQOS2ZMMh9BvNWaH6I4VIDg0q/UnCUuJPN1mJuJxkavLa+WfCFHVv60b5mgfTm+rKTktLxGFQpGIFkATWaCfYB4vc=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by DS7PR10MB7190.namprd10.prod.outlook.com (2603:10b6:8:db::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.28; Tue, 7 Mar
 2023 01:16:37 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::8ef9:5939:13aa:d6a2]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::8ef9:5939:13aa:d6a2%8]) with mapi id 15.20.6156.028; Tue, 7 Mar 2023
 01:16:37 +0000
To:     Salvatore Bonaccorso <carnil@debian.org>
Cc:     stable <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Martin Wilck <mwilck@suse.com>,
        Christoph Hellwig <hch@infradead.org>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        "Linux regression tracking (Thorsten Leemhuis)" 
        <regressions@leemhuis.info>
Subject: Re: Please apply commit 06e472acf964 ("scsi: mpt3sas: Remove usage
 of dma_get_required_mask() API") to stable series
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1356hnzd2.fsf@ca-mkp.ca.oracle.com>
References: <ZAMUx8rG8xukulTu@eldamar.lan>
Date:   Mon, 06 Mar 2023 20:16:35 -0500
In-Reply-To: <ZAMUx8rG8xukulTu@eldamar.lan> (Salvatore Bonaccorso's message of
        "Sat, 4 Mar 2023 10:52:07 +0100")
Content-Type: text/plain
X-ClientProxiedBy: BLAPR05CA0002.namprd05.prod.outlook.com
 (2603:10b6:208:36e::12) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|DS7PR10MB7190:EE_
X-MS-Office365-Filtering-Correlation-Id: cfd4d20c-0567-4774-ac9e-08db1ea99960
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FaHFFsad1bYr5tE/s6V7UFsuNG6+4n4s0Z0LfHxCUO5SshOPhP1IPWCgFnTeZrVHeIt88bSKx5/Sb1JgS1MgUKDw0uXVG0VL1x49jFe96ZSx8SuNC/nb85KYjjmzTjWut+mbLXQYMbzlj376RQA3dDsX5+qV2QGHj/Al57ehDKNEsWdJg/MUtl8GzZ5FEsnkhE627uZL864tGQBK3OsgnvKoEcY1TOXfvLk9FO4rUgplxBW3jj9ZB3BGl9Vq7FXdtnkLiLo3wVO091Ai9P/GMF+zDf9upyMLez6pcjvRbcFcu1eoZ8i3iIlD8sEDRJmxHuuHoacFOJBaX7l6pn+e3DM5/vbkYKrA7frxaCeIZbreE9MBcN2qoHBLqarFpdgB0yVk2R1OOwf1Dgp4MVmYcgSz7XB+chPtU0mM+y9/1PhOaQpuarbL1TItNpdTowefsVio3KBIL4q/ce/JVcHBtg7s2A+duRTgCeqCQzcmil3PUhAoevKJ0PCncPi+ads6oEOkMKcNvxeJcn6cZlyNYwXq/tf+K/ihz2Jjt1yQZZmlCqRtnURAV55+6u3uLbL5otr/6Quzeehv1cXnbiaKAGLvpHXArJUbkXh8KrkFRF8wAraoJJjaHOPPT4CKaF2fnSiMQ3Tb0eRzRziDE1gfYoWl9KNuQhJy73RTnoTwUeZxzen9eDQdb+6Snu50skPJ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(366004)(136003)(346002)(39860400002)(376002)(451199018)(6506007)(6512007)(6486002)(86362001)(38100700002)(186003)(26005)(41300700001)(66946007)(66556008)(4326008)(8676002)(6916009)(2906002)(66476007)(8936002)(4744005)(5660300002)(36916002)(54906003)(316002)(478600001)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Fc5W64z7rXGPAyOS2ViLScvEBIXmK/BRex6Lualy+uJfHm2EC9aoF3sUwsfA?=
 =?us-ascii?Q?iF8wY35YhF/XbOOvStNOMwf/jbFoxliwC2g2SJ4MsSNcPFvB5Jq5oNnbpfPD?=
 =?us-ascii?Q?DjvYc8iCM8J5CiN/OO1S69PmYPBHd3xSvN0C/u2dGNPZffk0VbUGq8bKL97i?=
 =?us-ascii?Q?eSz8VIrJMGuzuKC3fWEHXQKk0B+cHEPNkFh8eMf6xdjbMaJ96sambQLkPmDL?=
 =?us-ascii?Q?SOR3eWe8PYp7i0I2au8r0w/A/D3ff9RJQLNaE59jTnzMgfwtzIYkt0eRJAhv?=
 =?us-ascii?Q?SwU1KOKL1wDHWURHIG2lvlHkmP+ZktaEH2G358El9JGAC/cTRvQ0T8myEwlN?=
 =?us-ascii?Q?s58snrWen6SuHaT0R/0Y/8b3mChePAZ1vUTKVMg7fRfq7Wu+CbG6gHq9FxrT?=
 =?us-ascii?Q?PthU3/u2C1+gtArX9DHhirFVh/Z/c659qxUHWgfRvEKIiTMd4zr8+nTUNtEs?=
 =?us-ascii?Q?O0MtY+3/++Yejg55azenifVEMCbO7xZpY1XvBQsXRrhjXn3JPCOIsSou2r79?=
 =?us-ascii?Q?Us4vLcMI5cA1fFb4Hi4Thl92s+nm3eHSCsJunJTPaZz0Y5wk4tbQ9deBfE3h?=
 =?us-ascii?Q?tZPYOrDVL+NnvKcmLGDaPcM0SLl6rTqr9+lz7IRdelP7iad9of/t1/M9e8hI?=
 =?us-ascii?Q?4quEXnEEbQGChdpkf14QYd7Z+TiXvw9EienzvC5aPrKTyuPK0g7zN6S5/066?=
 =?us-ascii?Q?qdzIg+iAk4susLq9WiZL/MYUT4t0ZzBlyZPHbWuVxgavE2AKLoxbShJw2mTY?=
 =?us-ascii?Q?ZaeQXcBLZ2Joz50pmgz0n2BkIUgIujkH0/CeVicMFujhzvi+3VJAHOuK7lpY?=
 =?us-ascii?Q?DsTy0c7COhDfK8pHzNXzBtCkSv6AthxSkqxmIpUZuv4PrhHDJ2KZChBkMuOB?=
 =?us-ascii?Q?w8jEjgud67NbeQ3ALMo24zGO5Lqrr9YG/5QDWDkTKGYHs++sSdkR/kd3DLzI?=
 =?us-ascii?Q?dhAxG/AR8QRd0ZTRE6GinAfS8KJiMoL50lJY1l+axaDe/Fymq2kgdUgOnGJE?=
 =?us-ascii?Q?9y7H7MhkVHdR+hJ+joEzHyO06W5OAzqdeTbZmwu6yCptN+SxGwUQtTM7ZknV?=
 =?us-ascii?Q?vG1iWeUaVdHTAcQzYC1gM+cSOgWOVAzqmZjaaQGiuJjVbicTY4g8oH37r/xG?=
 =?us-ascii?Q?dYv/IA/SAYRoEmpUbPKfvm9ipv56g1Oe5+ZjQcNSwzWBQp0glWBA+lp6TVye?=
 =?us-ascii?Q?0WhCQCJ0/mrO/qquwMl7gzRo9RJ3H1VVZMeXG6Bm/nJsmjTxxE/PAdZiz+D/?=
 =?us-ascii?Q?t9xTbGowY7DpvtV+qYZOhIyyPPGjDlnAPiSwEAFMMbWwOXPLhkUVa9MOAxS8?=
 =?us-ascii?Q?Yn84gGnjR6/9A802aAPyYRcXw8QxkpNkeqkLr5bXvRN9HJHUl2F64763caIA?=
 =?us-ascii?Q?15tJoWDe8hMl2wyY8yFX7bUUuuu1kQH+iWaPh95me8Mk1lyoKNBE/B3L1PF0?=
 =?us-ascii?Q?7wl4LkYDK8z6YkNQVcsHcpXrsLQIJrVSXvnL2W1tGh9mYtMTT3k5XdKaEZ90?=
 =?us-ascii?Q?MG234G0/GY7zD5SD8QqtpkKt/jB9KPADZgET2R9APxsAESVUZlRhnX3hC+yC?=
 =?us-ascii?Q?NAq1ZlAJfVPH8G57ncaJEzkG+ys3ABIb24Tq88JV62CFASWGM3oWpGOd3nj0?=
 =?us-ascii?Q?/w=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?7LdfQuJJhmS0fIXteekPvDPZ9YDzFZ4sDYTVbAe4I+U0rEVkvW+sB9Mq7+Qs?=
 =?us-ascii?Q?8aGFxPTuQ26Ht0t2AuO0iWeGk6SrrasVt7RLjGqH1ay1wT28XG1MnGmMDJUN?=
 =?us-ascii?Q?pgPtcX3v7074O5JqIkZo5KQyTiuZnOZPRhpu7CFZ7ngel2Uy65PBU6HFd18i?=
 =?us-ascii?Q?SaLm5/gLY2WkNiK0CDomJCMjB7vxQWMpK47B2xmiMRGwlyf3eaNeTOGF65pt?=
 =?us-ascii?Q?XZwUjN1gTj36HAV1qRfL2l6QSNcvnUGvRS0+rzZHQdu3oLG/zNTKaj71Tm6+?=
 =?us-ascii?Q?4hJgYRbo+QsT7JfFpZP+gNUhZPg93FMmglABA1T7O1aG/5FxLRTsFpg96WTH?=
 =?us-ascii?Q?fFVEZakWbrkLDqkNE5y1nQ5c+Em4AbxsjgpwAs9PEvM7CF6qKuBj3ZmoBqcY?=
 =?us-ascii?Q?KdJNhMaseenWkMtMwVu3owGZax/ewW+BTebM7oOMFBqxdNt2vj/yqoViilQb?=
 =?us-ascii?Q?0RDemxVGboW89xGn5fCkh1I91kms0u/gHS/lBC26fSKGN2eCOmLItjOAW2JN?=
 =?us-ascii?Q?PoqxshSvunkdULpiJ7zbIXaDO3nH5EpWRihZNK7DEizuWC8330aPkXtvFITV?=
 =?us-ascii?Q?2kip8JPee7O66mnB/7giejw1pWoLFi7hC9R/R0c4sSo71SMzfphO4yTAdvBM?=
 =?us-ascii?Q?wuoTFkk/rX7hQfky5ESt9a8AbTKqbtSy0lXXoUIEL7bpA0ZZTtrbJVqz9pQJ?=
 =?us-ascii?Q?03my5sEe2RHv4xN0F/Wd5rPL2rQyirh774SvtDtz8Y71fr5myzbLcVZdD1kB?=
 =?us-ascii?Q?6gwbKsBEs1fLjA5OJO3+K3K1Bsbp/eaChfMocAQ1VN3mLq80a0MMQYOQr8fe?=
 =?us-ascii?Q?UCGhPzLLNysyNXPgdUY8gM2Hg3BTRA2SbeT49GVgoKF6o8CvR4QbyujUtn6j?=
 =?us-ascii?Q?9lW1b/bLXltsfLbkVlH2DSZtTmUoBFpsxyR2q3PSI0tQMYgFg65bkaoU6slC?=
 =?us-ascii?Q?lyZQalw86LKdT358qFEcVzl5Kv3Pvx4hYSK89eV22LpU6pYu1emlbKpo6MC6?=
 =?us-ascii?Q?ttIv?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cfd4d20c-0567-4774-ac9e-08db1ea99960
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Mar 2023 01:16:37.5863
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zLNZqwXDkaLryHP8vIEYmf2dZvRGkXlxRM79xViBdz8CCMjfQn5oPFlGjCuif0dO33B6tuj3jvGVZk2oSNuLlThIhN5DP2SYRAiZ7y342/Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB7190
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-06_14,2023-03-06_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 malwarescore=0
 mlxlogscore=783 bulkscore=0 mlxscore=0 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2303070009
X-Proofpoint-ORIG-GUID: AhY_Ze-Jh9snNSN11Qw_bk3hcerGnvHe
X-Proofpoint-GUID: AhY_Ze-Jh9snNSN11Qw_bk3hcerGnvHe
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Hi Salvatore!

> Sreekanth and Martin is this still on your radar?

Broadcom will have to provide a suitable fix for the relevant older
stable releases. It is the patch author's responsibility to provide
backports.

> as 9df650963bf6 picking as well is not an option.

Why not?

-- 
Martin K. Petersen	Oracle Linux Engineering
