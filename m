Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22293509DC3
	for <lists+stable@lfdr.de>; Thu, 21 Apr 2022 12:38:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1388461AbiDUKk7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Apr 2022 06:40:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1388463AbiDUKk4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 Apr 2022 06:40:56 -0400
Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D01225C72
        for <stable@vger.kernel.org>; Thu, 21 Apr 2022 03:38:06 -0700 (PDT)
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23L9s7KG014742;
        Thu, 21 Apr 2022 10:38:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=PPS06212021;
 bh=H393nmzoIqEoDQMY+vIrpMxTlbgjGVWIlOvGcEZ1aRs=;
 b=rO1pPm8XwwcN1NvGsWJ/ZlPJEzB/8HPuA7t44aT0l7m9eFdkT0E+XDYD/pH+RuUX4zvs
 0iRk9ObQcSg1txNoqnoaZqmT1pj7v8HyYlH/R650AlmzFldnPgPu4qAk2Irjxoli6VpL
 kUCScXVtvJwezmAOAuGBdSyr3v81ch5u4jP+YRujkgfUt99igNvXv1BK2EKg4mFMH6Db
 IaUaTuqAkkXobK8g1wESKbA13gwwqM9Sn3ZwmnSD53Q+nwNAEJTzXJQ/UFbRVme+FNpO
 uumyUIwN9ihORSkmmFR2w1VtL/2n075Ngsobc1e/BgmCa6A3CDouUIz66aS9ZcRVm/Df sA== 
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2102.outbound.protection.outlook.com [104.47.70.102])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3ffpqn3qyu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Apr 2022 10:38:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Crml+W/U/JPXw9QKhWC1Yijqpwr3NCU/q9QiwPkWFiPEM4O6mAT1/r5eTCYzhQZ9big6NbTuXtxOuQNetcM2zow1BAa6Xb4yDQZi4HPHdmWFgINyJN6MjBR3OuO4qO4Y5u4+fwJ6ViAhJvse4Z1+hzd36xVrcXyuF8kV0XG6C6RADYJ1EAgihFIibQ0v4/3pPbv3fPJbcCoYl4xpHXj32SBVb2GKH5VNVbInCTOOsUlAlHVpc1qkbxZaEWXx30MTVlSRTsnAq5Lf38iNOsPBz6UbNJwaV/OTnO0GtKFXfBil1oyLbRe0GNwf+E2h9Tb9mcYNXerz9wg3tR/9pp3jtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=H393nmzoIqEoDQMY+vIrpMxTlbgjGVWIlOvGcEZ1aRs=;
 b=joy73O1mPRkXqn6mVEnOp+ah9WNAWu7arPN8f7oHRgkcvB8uv44UMxdfrtCsjLmNEku/w0hncNOgj73LPAFFBwnYoHdoz4Gi/46rmZWWeXHxrHo9TaGumlG8LyfnRvmI0Q+rEJoF/RDLm90hFlOKxpAdgNqiJ0R84SsGJHR+bWvaXucqe7KrhxVSlrzKVw4QK9mPK2EjyZKFuBnxLeehgsFUf4CaUIGReLOxOejAx54VimcMPK9rXEW2ODPV2AcjcQArpwqBVvkofsjrim6CdltVsOXPXu+6MWATv4zW63OBt+Voc8k9ULQ8q/OfyTXUkvv9zwXtpXtW444Ez3TSjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by DM4PR11MB5406.namprd11.prod.outlook.com (2603:10b6:5:395::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.14; Thu, 21 Apr
 2022 10:38:03 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::c903:4c47:ac8a:992d]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::c903:4c47:ac8a:992d%4]) with mapi id 15.20.5164.025; Thu, 21 Apr 2022
 10:38:03 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     Duoming Zhou <duoming@zju.edu.cn>,
        "David S . Miller" <davem@davemloft.net>,
        Ovidiu Panait <ovidiu.panait@windriver.com>
Subject: [PATCH 4.14 3/8] ax25: fix UAF bugs of net_device caused by rebinding operation
Date:   Thu, 21 Apr 2022 13:37:34 +0300
Message-Id: <20220421103739.1274449-3-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220421103739.1274449-1-ovidiu.panait@windriver.com>
References: <20220421103739.1274449-1-ovidiu.panait@windriver.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VE1PR03CA0024.eurprd03.prod.outlook.com
 (2603:10a6:802:a0::36) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 59dee372-8719-4d79-fdc7-08da238303a2
X-MS-TrafficTypeDiagnostic: DM4PR11MB5406:EE_
X-Microsoft-Antispam-PRVS: <DM4PR11MB5406EB2D6EE85BB99B166A49FEF49@DM4PR11MB5406.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qGA7TAxU2MlvAKC++CCkdiq0LgQ6lc/8Gyll610mNdDCSK03pr4wsKS3J01tsjWG9pZ2TMgJ27IT4c+P6lZbfy5EiU8mqCWSJ/FOCf4zxHkQrpeSXt1XCEWu17t+HkG2kG1xRPHntPAo/Imyx21ld5ODsNDcDqGZT1KHLhqH2Qlm1dyth9bfhVNOPaBZGi+38z+lHJVLHOo3vj4adG4NF7ypeDiFnc1vB+ZIHVKdK4vm24TlOxsJDCfe2JnMq4H6U3Ip9ikXQsFPJlUdIunWYucm1suR8SUoGHRm4lW2trvIUbIHH7ordyG6Tlnzk/AKQK6NZ1X9b9+KkcrANtSc0zW1wg3UqA0YKxLJSckqVnnM0pCKov05MNJx0QDZYWP+JUaBJDWwphB7DC3RYs9HT0Zd9JceelrP+gIbfL0zTg2obmIg3TuU7L8B5jAx2rCcJVSwzSrC2SreN05Sbr4iQqH0KHtGXm6OMmA00z/xLHMwsbjZVH8v+Cipnq8G3Gvq8wG3SusFoYqr3DtsEreMyTlWiw+x7/poPa2CKNg5SubD8V7pUYM3G0XhGTaLc4K0UCRTclBvX7YSNJcwQkzTKN9klvJbAbgLkEqlyomlJotk20vxdJEf1tc+W2nM41/PMQV1UavNzOEcZHseJbAkNGHKw4JLG1gzIXswR9qntqRaHOs5cyn8b7iveKChJbQ1KYeQrgjT34BgoNPQVgOJ2w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6486002)(38350700002)(38100700002)(26005)(508600001)(8936002)(86362001)(6916009)(316002)(54906003)(52116002)(36756003)(186003)(107886003)(4326008)(44832011)(66556008)(83380400001)(2906002)(6506007)(66946007)(6512007)(5660300002)(1076003)(66476007)(6666004)(2616005)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?JbKSk1UiqBcGWSvNqTTaiZ/gwT5uzMfpS5wrc/Flq2t2ZnIwbsria1JEjHAe?=
 =?us-ascii?Q?Ze4etE3kJhvLNpKMSadXORwfyIJmP9PuVgh0+WqHkKsX76vvBfflD/corL8n?=
 =?us-ascii?Q?vIr+B6IoibHM58iMliP2Ot04j2XPbFctZg0tXrsK52bEJ1lc+W+fVoH8xAPD?=
 =?us-ascii?Q?1YVvXrB/rXOtDrErnNJ/CsYWqzhLDkb1WAXcdqS8ullcsZEi1PkvTammiGnT?=
 =?us-ascii?Q?gvDII3sHZkGo4oXpizBWaq+xlFextLZw55QN6nsyv3bAyFpm9w14VqfZdXQu?=
 =?us-ascii?Q?iIJ8NdLSgfZ+iwcnnEChI9QxPg2b0EkWQPlzUrWEQNaZWsSAaRZvZPRtQl4j?=
 =?us-ascii?Q?tPNiHxmljXwchzlDvAdiA1IOS1v1hfeeOfly17mLgeS7OtYTV1bVYK/8XbbU?=
 =?us-ascii?Q?QL0DQDTM1H6Xw9UQA1yfzQrU9ccALhM8hZH2e4Fx5R2wh3f6ck0ApeYc4L7w?=
 =?us-ascii?Q?oKBZL7dKtZBcjjVHictBScqAoke9x6bgbptq66N5pTqEYD4WLz6lilGTDRav?=
 =?us-ascii?Q?69d2FC+U7qsIJ0XGbcUXQO9Y71cMs1HgC1gvSOHms31rJNyn0Qr3JJWOyXqW?=
 =?us-ascii?Q?mHDGrP0pBtGzp7w/IiWI0+rPTLJZ0IOTAD9VBhVMz7VuXaBJoEtiJz/OHJaW?=
 =?us-ascii?Q?Ib/sr9wE4LxuoXoV1BkfarWJi7XaZGUvPKuI1uiN6wZSUfBRl38Y6oS3MZGM?=
 =?us-ascii?Q?cZbuABwkfNyu3pBh+5dGhn+WNHr+qPNxoFcAf2vcp77NF4qt07tpAkTXvTl9?=
 =?us-ascii?Q?rSDysCsiHiVpxXvhRwoOvb9HBoNrLHX5GIsgVqBdzk0tF5fDJP+BjBQo76C/?=
 =?us-ascii?Q?ehMO1pW/7Xn6nD2tAjI/JFOAcD3rBhuq3QUdEjVOwAvFrqUZbSvxUxSijwNw?=
 =?us-ascii?Q?XeH05PzYg2CCI4MfDCb3YXVIC+GLGwZKlmFwThAsCr1/DgzDhuP+NcogGSHo?=
 =?us-ascii?Q?RI0GIv7lw43AnviUTfCCWkVrMqw0HjUv6tfJC+mPv6VueOSos4ZjUXi0Uwbn?=
 =?us-ascii?Q?ML7gICTBOUn5eWPz6CMAGbi5AVFeptjvFxKLBSNTJoVaAAzyoWrs3HSaCCvt?=
 =?us-ascii?Q?rmkzXoB0dEe6PEX4NAMyJ0cv0IHgrVhwwAgUjoOBlNh/UYsw+HH1/64qdJiM?=
 =?us-ascii?Q?TnhehqZEcooNKbbGGb1WjoM8qPEcx8iVyNbi+Fg3mJ10MdKT/Ps2P+lOWwx5?=
 =?us-ascii?Q?ErF08j+eDjITXEV9na+PqFKbPFf8CqOVjfFk4M2qm/LqmlvP78/TigWTEER0?=
 =?us-ascii?Q?fLkgo4hK3iOcbfL68pATxJJscui+Lc+sWoR8XywFEflrRzFCr0QZzHhDuptO?=
 =?us-ascii?Q?u6nvrjbMLUWK6LxQfe7iU8QfoCxSyMSWBZDBu+7n1b/7fd/e1vPPF7zoKBGA?=
 =?us-ascii?Q?PeW0XiBFTsx66HDr02Lht+p/aYuEs5Xusb5eE427Hj12cRvbTrga4RafSq+h?=
 =?us-ascii?Q?2AQtzDHh/BtbdA+/yBPs9W1IxNQLihpptaHIZZyk5v9PdkvmdUNcEl+vqTVp?=
 =?us-ascii?Q?NtiL8aWoncXqxgqimpSybd26h5SOtdpJOgmG5OQ0KKB3OEVq90cUmkpAU46n?=
 =?us-ascii?Q?xp6T2aLurLOpqha8HZM1GjvhjuxajdaBJIcYzQ6sLdpaZ0iUswvaE2wfoxX3?=
 =?us-ascii?Q?nWsxbtOrZoZwxg/0lgiqujkF9TJwSH+j264k+ctgxOYaRn/pewmdMiu1kUzk?=
 =?us-ascii?Q?PicCMngzfEi4F3lUZG/Le25tf9Pn8KekBPRzvKGBWyfMuaDgTOmdw7x+8V27?=
 =?us-ascii?Q?AFLVo0cfKRDErVx4Tz7Z296/NOVUriA=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 59dee372-8719-4d79-fdc7-08da238303a2
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2022 10:38:03.6141
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rhpD/ioR1COvglCN3/o9mhpq/wtUC9VUspUwOYa7dx3/FodYoEbGTm+c2/pao862da1Z4fxyb0tXXt3b8tcOvy1bC9uX+qksXUzPEGqMpBs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5406
X-Proofpoint-GUID: Tq3yXS8ebQ4FY9QnXvuapetHff8qzXv9
X-Proofpoint-ORIG-GUID: Tq3yXS8ebQ4FY9QnXvuapetHff8qzXv9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-20_06,2022-04-21_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 phishscore=0
 impostorscore=0 spamscore=0 lowpriorityscore=0 priorityscore=1501
 malwarescore=0 clxscore=1015 suspectscore=0 mlxlogscore=598 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204210059
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Duoming Zhou <duoming@zju.edu.cn>

commit feef318c855a361a1eccd880f33e88c460eb63b4 upstream.

The ax25_kill_by_device() will set s->ax25_dev = NULL and
call ax25_disconnect() to change states of ax25_cb and
sock, if we call ax25_bind() before ax25_kill_by_device().

However, if we call ax25_bind() again between the window of
ax25_kill_by_device() and ax25_dev_device_down(), the values
and states changed by ax25_kill_by_device() will be reassigned.

Finally, ax25_dev_device_down() will deallocate net_device.
If we dereference net_device in syscall functions such as
ax25_release(), ax25_sendmsg(), ax25_getsockopt(), ax25_getname()
and ax25_info_show(), a UAF bug will occur.

One of the possible race conditions is shown below:

      (USE)                   |      (FREE)
ax25_bind()                   |
                              |  ax25_kill_by_device()
ax25_bind()                   |
ax25_connect()                |    ...
                              |  ax25_dev_device_down()
                              |    ...
                              |    dev_put_track(dev, ...) //FREE
ax25_release()                |    ...
  ax25_send_control()         |
    alloc_skb()      //USE    |

the corresponding fail log is shown below:
===============================================================
BUG: KASAN: use-after-free in ax25_send_control+0x43/0x210
...
Call Trace:
  ...
  ax25_send_control+0x43/0x210
  ax25_release+0x2db/0x3b0
  __sock_release+0x6d/0x120
  sock_close+0xf/0x20
  __fput+0x11f/0x420
  ...
Allocated by task 1283:
  ...
  __kasan_kmalloc+0x81/0xa0
  alloc_netdev_mqs+0x5a/0x680
  mkiss_open+0x6c/0x380
  tty_ldisc_open+0x55/0x90
  ...
Freed by task 1969:
  ...
  kfree+0xa3/0x2c0
  device_release+0x54/0xe0
  kobject_put+0xa5/0x120
  tty_ldisc_kill+0x3e/0x80
  ...

In order to fix these UAF bugs caused by rebinding operation,
this patch adds dev_hold_track() into ax25_bind() and
corresponding dev_put_track() into ax25_kill_by_device().

Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
Signed-off-by: David S. Miller <davem@davemloft.net>
[OP: backport to 4.14: adjust dev_put_track()->dev_put() and
dev_hold_track()->dev_hold()]
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 net/ax25/af_ax25.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/ax25/af_ax25.c b/net/ax25/af_ax25.c
index e699bd80a861..d9b3f6222cec 100644
--- a/net/ax25/af_ax25.c
+++ b/net/ax25/af_ax25.c
@@ -101,6 +101,7 @@ static void ax25_kill_by_device(struct net_device *dev)
 			spin_unlock_bh(&ax25_list_lock);
 			lock_sock(sk);
 			s->ax25_dev = NULL;
+			dev_put(ax25_dev->dev);
 			ax25_dev_put(ax25_dev);
 			release_sock(sk);
 			ax25_disconnect(s, ENETUNREACH);
@@ -1126,8 +1127,10 @@ static int ax25_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len)
 		}
 	}
 
-	if (ax25_dev != NULL)
+	if (ax25_dev) {
 		ax25_fillin_cb(ax25, ax25_dev);
+		dev_hold(ax25_dev->dev);
+	}
 
 done:
 	ax25_cb_add(ax25);
-- 
2.25.1

