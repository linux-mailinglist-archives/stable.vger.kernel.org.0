Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2FE351D40D
	for <lists+stable@lfdr.de>; Fri,  6 May 2022 11:12:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352619AbiEFJQ0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 May 2022 05:16:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1390358AbiEFJQX (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 May 2022 05:16:23 -0400
Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 560596339F
        for <stable@vger.kernel.org>; Fri,  6 May 2022 02:12:39 -0700 (PDT)
Received: from pps.filterd (m0250810.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2468iumB011524;
        Fri, 6 May 2022 02:12:24 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=PPS06212021;
 bh=BgCNmwO1BoN92I1PSYiX9sR5Rge9/HsXU+OIjY/oo1c=;
 b=I4Effqb7xCfYkT/lxJ+RSI2dKCKGwthk0RRbRXP1GPoKINQ47pyigk/FBlFyZNDzjNJJ
 Y8Mr4spLb/fHEBb+RcgabBxAKh5FtdqFivBruU338wpmHRxtZWs7nQ3uKzVQb1Ki8ZYb
 bu3pVIkkJ13U0IsjGdh7LUkWKpX3DssuwUPRals6eb3tYTZpr9UHRpzA360tcWCbHvis
 gzosACZe0wfn6oIhymEHpfECy1DXmDOLkMD+AD+wL5G92rw1hU6Evxtgx8pWdB6B3kxn
 Jm+mtzstM1HHt6Zm79aKiuM5MXpgR3mrtaF8yN+FdA5/AxK0GXdCdfoXozzBx6TtTXag eg== 
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2100.outbound.protection.outlook.com [104.47.70.100])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3fs0d3cerd-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 06 May 2022 02:12:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PGSdu1S1UiSJRghKtY+WIByhM/qrfBYVueGYUBC9D7sFHMBHHvFN7C6dvFIkTnaau7YM8K4yM8Ir5HApH33R5L5L9OYuRmnQJLiMJBOwmEN0wGhfkj+kzpaTHCu6T8aCIkKNgvq7i15/CaCvadFkeIoRmhU71EwIu7Jo5ONWkha6mH9vZdtyPlbVAk3iagzSxXeew56EVw1YeKQH6tb94gjqPETAjIhy3hjv38p6mvy+zb5nPUWMgV7GseBQO0KooMBKNKA1liySIQCDJ9GneRTeWRqJ4DZ2rfFOu18YwLcs8q+Jut6qJBqpzkKWn3PpuQRtLc4zPfWljbOzI182mg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BgCNmwO1BoN92I1PSYiX9sR5Rge9/HsXU+OIjY/oo1c=;
 b=XvVdnvHPEpNX6G4m+B3vmFhdLof3Jl1WDx2CKxmybGK2AbN5roxZ99arn2DJlrZ5SfNgsNRbk1bo5DAJ/CeZ6KVijEkoArGCMVewvFen110CD7BXj88TDDhl+2Kl+JpyQNCnwQoo0iV7DmiFHXOWKAX06nIj2nYwbjpK90xzps7ck9OGBP8z6k9TNW5H3hpY4cnTiqlemoDmuBdYqCNtPfyTvcEgOGXSpVl941ldnYZmS41xz2ahIZFfU4vL6c8CMfyVRhsNXQU5SkLR9WcWieCBtH3NltjUWo3sLzUsCOwBm5MtyW89DVV99loLCCGK+Sb5CQQD4TB3IiV3jly8tQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by DM6PR11MB4444.namprd11.prod.outlook.com (2603:10b6:5:1de::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.24; Fri, 6 May
 2022 09:12:20 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::806f:3f7a:c1be:ff34]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::806f:3f7a:c1be:ff34%8]) with mapi id 15.20.5206.027; Fri, 6 May 2022
 09:12:20 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     tiwai@suse.de, perex@perex.cz, kirin.say@gmail.com
Subject: [PATCH 5.4 0/5] ALSA: pcm: backports for CVE-2022-1048
Date:   Fri,  6 May 2022 12:10:08 +0300
Message-Id: <20220506091013.1746159-1-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.36.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VE1PR03CA0009.eurprd03.prod.outlook.com
 (2603:10a6:802:a0::21) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 19b902af-dc49-459a-781e-08da2f40862b
X-MS-TrafficTypeDiagnostic: DM6PR11MB4444:EE_
X-Microsoft-Antispam-PRVS: <DM6PR11MB4444277D366F9911812A7805FEC59@DM6PR11MB4444.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QMl9Xg3tok5WrV8n5JQJezW+2xvAx6Lh12CY1O5RMCoaFMflQTymDW/RdRHSDKNrZ7JeFPhNQU9IQBn/5/YO0ecEoscj0W444sK2TwlFLrOznaCQt0Ok3cFntTS9uMg8lHHyb0zZtY+Xjc6Wt+RgMA1iaDyXTDw5IaKuXDtdNASY6faNfXEmwLtt7Hrr3QYHAAm4PacbVDYEVCTlXFcUG9PvBe81+/Kc8eFbAxb19F1n+eMa23VYNrEQu/dy2tfrDhgjYvt6zBm11RBNrlJCbolN2jcv5e+Kho0tHjiqO4AppAkcIfDE7UVyg2bVMTaT7Od9ousVWBG0t7eXwSB/f6mGKpXSQ4Qa/5JpG8QIVtSBr6NFpOOrVRH/VmsNWCjYrDQDXjgka9aAd0k0aCBb2Sb5JvO/GzOFOEnj0SOKilf7g3C2ofk5wdDGnulIsbePnQ1ovfWS851u3fDoP0i16HTrvHFgmEa+exUwBZMeSDnwlOWXFTXA/zdFG4tBn+vVQakRmXAdGZQV04WGLhCdexlGezsyk/6spUAMveiudVaOjhMDeAqzkqY/DkS6e3vEgzzMbZ+8yjvdTPsK8omWk/A8l8JGAxs5QniSPTVL4vqAnYe27IbpOzz1QWPP2EXzjV4YlIGHAMkflYTah+AmYCGdgiKazxMyr06iT76MN5wRZLwUs+jeryoMmCIdb3G10xsxKPGzHbLZ15ipozSDrgg4nZM5NyonKL4BYyegY8u5g8DXwCp8NUkVxww9LrebkT1Z+fJPIIMc3MFVFmlXEzpbuanEN1ROKLdnuErGRNo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(966005)(508600001)(6486002)(5660300002)(4326008)(8676002)(66946007)(66556008)(66476007)(8936002)(45080400002)(186003)(83380400001)(6916009)(6506007)(86362001)(316002)(2906002)(26005)(6512007)(1076003)(38100700002)(38350700002)(44832011)(52116002)(6666004)(36756003)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+cYsp/jKX/SSgaZdC0TZD9KUk9RwcGNKyxgc8/MH7dk3Xjkg28yRVhAns0Lv?=
 =?us-ascii?Q?RR74lWsNo7ZTbkCDrP5Z0LUj3/3+7iYbLN/waXJSdfWs7zP3TvlOW8IyDxGj?=
 =?us-ascii?Q?cG2VOeMXYjzI5G7EZkBJmsZfzFZ0Jz11dBOll670gLajsFVW/55VZeFf+5hL?=
 =?us-ascii?Q?VCQM2y25PPtaI13KRIbolmTvbezIWA1pHVzEQjasMRWIvjIMA9bo9/dG3rCq?=
 =?us-ascii?Q?R3dBfVogUhJ7sEW3xvtFqkLnxxeGrmUfgLmtsiu/twq/sgCkSxcS4X43iwQu?=
 =?us-ascii?Q?ZJ3mWgIItmUUZINC7rEjfzODJeRpbM+StWw5U6TMPDwq8G/uq07XYxPwMkNr?=
 =?us-ascii?Q?qmZsz3DX6cyrqhzNmiaT0UWVpJrHd8hjYDt61QF0ozLE8HyWLbN2MgFCPaUm?=
 =?us-ascii?Q?Hb2uBwVvOxc+GI2rWw4oNXgFVjIk7Y93WXv4dUrsgEsSi5v9hykq37h1fOj3?=
 =?us-ascii?Q?bM36uW4h1raraIRYy9E1Kf2SiVn3CH2CPTpQWfbM5vZSAjYCBD8jdXOJgmm+?=
 =?us-ascii?Q?KalNm6jCuueLDTPhb6GqUKNtixCjDtsGXhChwQdlurZVF881vF4vCqwHRKQx?=
 =?us-ascii?Q?yfeia2WAz62849YgxpjFGvPlro5JCz3MXj0rH8C6nItEYFkTJ7C+XyaMfSTU?=
 =?us-ascii?Q?K+Z5yzTXYc9OLKRla9YBF/cZnAOk1BClDjjKQSTj1djdzZ8yxT8ZQjNK6yg8?=
 =?us-ascii?Q?CuK9Ak4FzdpMI0gt5CaAbhs2kfa6/0+QoNVtZjCzo7MaXtnpjwyILGAkN4rp?=
 =?us-ascii?Q?ZEcQ+TxzXlJ6abq9CmbtLFc09kdyn5u8iYwDUUW6m6ZEWcy+KYyqp6+g6KoE?=
 =?us-ascii?Q?v0Vj+i90igMpbNKuieVLBaGdNjWKq51WQdpZu/kEoYcgDZyUPUFB/2r8VXcc?=
 =?us-ascii?Q?q/jINgnCMcpPIx8fcPCyNZVH9KbumD0qxHa27gMeSLhk+AZhwLMV4T1HS7+G?=
 =?us-ascii?Q?F0WDPr1L3fXEa8vN7L1v5eEnyO69pcuD3Fsv8znBixsCBQIExKLFXe39fxNv?=
 =?us-ascii?Q?rRJv8KsJrTSUX9ei0mcW+6CzDQCVbRHHC6uAzZG3jB4hNMU/4qTr+IlvLAIf?=
 =?us-ascii?Q?vZ+u1DyFvYF6IZzGEHmTxrMBFu+aWXBqieKsxgwIftaGj+ien+d62Mkm4T+c?=
 =?us-ascii?Q?gRNKY/MxPKGSW4hQtn8O+zNvXKnlMl0ZLOJUYDc8+qRMrExTlKgbIUrxZ2cz?=
 =?us-ascii?Q?sysw2lHcfGyXLHi/UwAX5tdinZ0N1+pZHmwsbNfx+GaenuNm3hdye4FXbran?=
 =?us-ascii?Q?UXBignrXlLCwOUpNoouIzh/o55ToSGkfCC0d7lDTOc/srn3slYACNlRa9oqO?=
 =?us-ascii?Q?oeQkbc9Uu94MrJYYpqqb0uMzjwOwrjzX45LZEk/t1vfLlGXFEqxoINQ5k8J0?=
 =?us-ascii?Q?M4ci3OYL247IY55pKNVj68EpzNv6My/xaQyKNKTkPKpHEqFt3rbHPu39WE3o?=
 =?us-ascii?Q?GNTdc7/fhO0UU5U3nVycfkPX/r9hmFbjN9el+jVFGDwYJ/w8TUEGYymDsI8P?=
 =?us-ascii?Q?JHxKTx0t4sR0qZDgqbSIARYX+4OjRqpB3Brx0O5DQdxb3w6QB0Tji3scfGlD?=
 =?us-ascii?Q?FFHgMnjx9GqCQ4y4ZUFsIflQSxUkkpqfK0T4FCFFs7DZMkdNbJXy0jVPjuqk?=
 =?us-ascii?Q?F2rKsv/JzptCcbE/y/yid6oDRb9r2/DIVUqg7Jg9DenLjaNF66PgVw4pgGFa?=
 =?us-ascii?Q?l9VeDMkpakRILK3SrtkoD6HuADwXBsP6cYtrKKQSw0E42aSxLmN0FKqE1WAi?=
 =?us-ascii?Q?0XLhWI7aWg4FWmJAXK3pO9GkAn7WwYc=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 19b902af-dc49-459a-781e-08da2f40862b
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 May 2022 09:12:20.3629
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xrJpnwE7Ll7dhxl7UWMwhzSdsJf9frNjTMenbPSHAFOdJh2lHORLUa8JPa7nk3XPpeLT1CaktdDhGd+lbSyUFzxXg2fSPt8eAxFwjkPVToM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4444
X-Proofpoint-GUID: Gwl_PUTuqwjzrH4A7e2wcf3qB8i4jfVG
X-Proofpoint-ORIG-GUID: Gwl_PUTuqwjzrH4A7e2wcf3qB8i4jfVG
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-06_03,2022-05-05_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 clxscore=1015 suspectscore=0 lowpriorityscore=0 phishscore=0
 impostorscore=0 adultscore=0 mlxscore=0 mlxlogscore=552 spamscore=0
 malwarescore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205060051
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Contextual adjustments were made to apply to 5.4 stable tree.

Testing
-------
Running the PoC from [1] on 5.4.191 kernel produces the following oops:

qemu-system-x86_64 -nographic -serial mon:stdio -serial null -enable-kvm \
-net user,hostname=qemu0,hostfwd=tcp::36074-:22 -net nic \
-drive file=rootfs.ext4,format=raw -cpu host -m 4096 -kernel bzImage \
-append "console=ttyS0,115200 root=/dev/sda rw ip=dhcp " -soundhw ac97 -smp 2
root@intel-x86-64:~# ./poc
...
[   95.839647] BUG: Bad page state in process poc  pfn:bb860
[   95.841277] page:ffffea0002ee1800 refcount:-1 mapcount:0 mapping:0000000000000000 index:0x0
[   95.843521] flags: 0x100000000000000()
[   95.844539] raw: 0100000000000000 dead000000000100 dead000000000122 0000000000000000
[   95.846306] raw: 0000000000000000 0000000000000000 ffffffffffffffff 0000000000000000
[   95.847164] page dumped because: nonzero _refcount
[   95.847705] Modules linked in:
[   95.848063] CPU: 0 PID: 357 Comm: poc Tainted: G        W         5.4.191 #6
[   95.848839] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.13.0-1ubuntu1.1 04/01/2014
[   95.849847] Call Trace:
[   95.850145]  dump_stack+0x76/0x9c
[   95.850549]  bad_page.cold+0xff/0x124
[   95.850980]  ? si_mem_available+0x2f0/0x2f0
[   95.851464]  ? _raw_spin_trylock_bh+0x120/0x120
[   95.851988]  ? __module_text_address+0xe/0x140
[   95.852494]  get_page_from_freelist+0x16f9/0x35b0
[   95.853034]  ? __isolate_free_page+0x460/0x460
[   95.853543]  ? save_stack+0x4c/0x80
[   95.853938]  ? save_stack+0x1b/0x80
[   95.854343]  ? __kasan_kmalloc.constprop.0+0xc2/0xd0
[   95.854897]  ? snd_pcm_lib_malloc_pages+0x2b8/0x680
[   95.855433]  ? snd_intel8x0_hw_params+0x106/0x550
[   95.855964]  ? snd_pcm_hw_params+0x2b5/0x1290
[   95.856438]  ? snd_pcm_common_ioctl+0x332/0x1a20
[   95.856954]  __alloc_pages_nodemask+0x274/0x610
[   95.857460]  ? __alloc_pages_slowpath+0x1ff0/0x1ff0
[   95.857992]  ? snd_pcm_hw_refine+0x8de/0xdd0
[   95.858467]  ? kfree+0x8c/0x230
[   95.858823]  __dma_direct_alloc_pages+0x18d/0x390
[   95.859339]  dma_direct_alloc_pages+0x1b/0x170
[   95.859827]  snd_dma_alloc_pages+0x1ae/0x380
[   95.860294]  snd_pcm_lib_malloc_pages+0x371/0x680
[   95.860812]  snd_intel8x0_hw_params+0x106/0x550
[   95.861311]  snd_pcm_hw_params+0x2b5/0x1290
[   95.861780]  ? _copy_from_user+0x70/0xa0
[   95.862214]  snd_pcm_common_ioctl+0x332/0x1a20
[   95.862699]  ? up_read+0x10/0x90
[   95.863070]  ? n_tty_write+0x7ba/0xf70
[   95.863484]  ? snd_pcm_status_user+0x120/0x120
[   95.863974]  ? _raw_spin_lock_irqsave+0x7b/0xd0
[   95.864473]  ? _raw_spin_trylock_bh+0x120/0x120
[   95.864975]  snd_pcm_ioctl+0x62/0xa0
[   95.865382]  do_vfs_ioctl+0x9af/0xf30
[   95.865790]  ? selinux_file_ioctl+0x3ca/0x530
[   95.866271]  ? ioctl_preallocate+0x1a0/0x1a0
[   95.866739]  ? selinux_capable+0x20/0x20
[   95.867172]  ? __fget_light+0xab/0x4c0
[   95.867588]  ? syscall_trace_enter+0x50e/0xb40
[   95.868074]  ? iterate_fd+0x180/0x180
[   95.868478]  ksys_ioctl+0x59/0x90
[   95.868853]  __x64_sys_ioctl+0x6a/0xb0
[   95.869278]  do_syscall_64+0x89/0x2e0
[   95.869681]  ? prepare_exit_to_usermode+0xec/0x190
[   95.870213]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[   95.870764] RIP: 0033:0x7f6f375c8717
[   95.871157] Code: 00 00 90 48 8b 05 69 57 0c 00 64 c7 00 26 00 00 00 48 c7 c0 ff ff ff ff c3 66 2e 0f 1f 84 00 00 8
[   95.873187] RSP: 002b:00007ffdbdb71b48 EFLAGS: 00000206 ORIG_RAX: 0000000000000010
[   95.874009] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f6f375c8717
[   95.874780] RDX: 0000564d6f23c2a0 RSI: 00000000c2604111 RDI: 0000000000000003
[   95.875555] RBP: 00007ffdbdb71c20 R08: 0000000000000000 R09: 0000000000000010
[   95.876322] R10: 00007ffdbdb71a27 R11: 0000000000000206 R12: 0000564d6f15e120
[   95.877093] R13: 00007ffdbdb71d00 R14: 0000000000000000 R15: 0000000000000000
[   95.877864] Disabling lock debugging due to kernel taint
[   95.881630] ==================================================================
[   95.883522] BUG: KASAN: double-free or invalid-free in snd_pcm_lib_free_pages+0xe1/0x230
[   95.885570] 
[   95.885976] CPU: 1 PID: 371 Comm: poc Tainted: G    B   W         5.4.191 #6
[   95.887787] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.13.0-1ubuntu1.1 04/01/2014
[   95.890095] Call Trace:
[   95.890505]  dump_stack+0x76/0x9c
[   95.890859]  print_address_description.constprop.0+0x16/0x200
[   95.891454]  ? snd_pcm_lib_free_pages+0xe1/0x230
[   95.891940]  kasan_report_invalid_free+0x61/0xa0
[   95.892429]  ? snd_pcm_lib_free_pages+0xe1/0x230
[   95.892921]  __kasan_slab_free+0x15e/0x170
[   95.893350]  ? snd_pcm_lib_free_pages+0xe1/0x230
[   95.893843]  kfree+0x8c/0x230
[   95.894163]  snd_pcm_lib_free_pages+0xe1/0x230
[   95.894633]  snd_pcm_common_ioctl+0x599/0x1a20
[   95.895089]  ? snd_pcm_status_user+0x120/0x120
[   95.895543]  snd_pcm_ioctl+0x62/0xa0
[   95.895912]  do_vfs_ioctl+0x9af/0xf30
[   95.896292]  ? selinux_file_ioctl+0x3ca/0x530
[   95.896752]  ? ioctl_preallocate+0x1a0/0x1a0
[   95.897184]  ? selinux_capable+0x20/0x20
[   95.897589]  ? __fget_light+0x2ab/0x4c0
[   95.898002]  ? iterate_fd+0x180/0x180
[   95.898385]  ksys_ioctl+0x59/0x90
[   95.898739]  __x64_sys_ioctl+0x6a/0xb0
[   95.899139]  do_syscall_64+0x89/0x2e0
[   95.899521]  ? syscall_return_slowpath+0x17a/0x1e0
[   95.900013]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[   95.900532] RIP: 0033:0x7f6f375c8717
[   95.900905] Code: 00 00 90 48 8b 05 69 57 0c 00 64 c7 00 26 00 00 00 48 c7 c0 ff ff ff ff c3 66 2e 0f 1f 84 00 00 8
[   95.902809] RSP: 002b:00007f6f30b72ee8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
[   95.903572] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f6f375c8717
[   95.904294] RDX: 0000000000000000 RSI: 0000000000004112 RDI: 0000000000000003
[   95.905009] RBP: 00007f6f30b72f00 R08: 00007f6f30b73700 R09: 00007f6f30b73700
[   95.905723] R10: 00007f6f30b739d0 R11: 0000000000000246 R12: 00007ffdbdb71ace
[   95.906442] R13: 00007ffdbdb71acf R14: 00007f6f30b72fc0 R15: 00007f6f30b73700


The testcase runs successfully after applying this patchset.

[1] https://www.openwall.com/lists/oss-security/2022/03/28/4


Takashi Iwai (5):
  ALSA: pcm: Fix races among concurrent hw_params and hw_free calls
  ALSA: pcm: Fix races among concurrent read/write and buffer changes
  ALSA: pcm: Fix races among concurrent prepare and hw_params/hw_free
    calls
  ALSA: pcm: Fix races among concurrent prealloc proc writes
  ALSA: pcm: Fix potential AB/BA lock with buffer_mutex and mmap_lock

 include/sound/pcm.h     |   2 +
 sound/core/pcm.c        |   3 ++
 sound/core/pcm_lib.c    |   5 ++
 sound/core/pcm_memory.c |  11 ++--
 sound/core/pcm_native.c | 110 ++++++++++++++++++++++++++++------------
 5 files changed, 95 insertions(+), 36 deletions(-)

-- 
2.36.0

