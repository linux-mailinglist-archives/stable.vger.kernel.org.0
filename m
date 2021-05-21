Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0A8038CF63
	for <lists+stable@lfdr.de>; Fri, 21 May 2021 22:53:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229455AbhEUUzN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 May 2021 16:55:13 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:23494 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229550AbhEUUzM (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 May 2021 16:55:12 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14LKgj5E007546;
        Fri, 21 May 2021 20:53:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=Qqe5MJiSqR1PBVzwd+cudDiMzceymzpnr+mZoC13gRo=;
 b=mWVGShGpbvSW/WB9b2T/Q8OW3B1YPBc0Mma2TJmH7gaBDAMoOIBfv6yo/yFNOlAk2Usr
 7S2RyPxD/qP92VLupOCGga5IQEjCmyrfPRQdBDHbQQENXoNi+UDtI3yJE+Ue/wgrZgUd
 dR4qIGlSBrctsNxyWgKMd9jNQT+iEGVMYfJeG0TXwYr83XIZWWuwwLyyZIGpx/3wfTwO
 qPBexVqpYmnUzBrmOjUpEZ1D/SqpYCYB2tlk0DRMC/+syoQeASXDzUtArTtZUaJAxn/4
 /9UamJyevK9LRyd+Hu8R4qglX8Mf4I8bBjNCmj9mtTVTKmFeD5nBI1ieKD4ABLYXnoLY Yg== 
Received: from oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 38n4uts2j8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 May 2021 20:53:41 +0000
Received: from aserp3030.oracle.com (aserp3030.oracle.com [127.0.0.1])
        by pps.podrdrct (8.16.0.36/8.16.0.36) with SMTP id 14LKj6i6107409;
        Fri, 21 May 2021 20:53:40 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam08lp2043.outbound.protection.outlook.com [104.47.73.43])
        by aserp3030.oracle.com with ESMTP id 38meej2cwh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 May 2021 20:53:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lyfksbIkdDYnIy0JUteVePGj3vDabTIOR8wSAV8Gm1/m5Yzea8k8B/9RV16DnBLK5Gb8e58NJVZH8Ap1HQgGBcRZWfapt1j/59kVPbfm7sfgotsyObq8uX5+aHlqYK7UOZTGwKFgBJAFXGG8o1wZc+c8FoBy2tFvcMzPkLqxd3Q9dPb+6scpvUIyeO1fGIspV/A/4Ufxb1G4GLDEfVb9hVWBKQgd1LIZArDW8kBr/KoLbZ2LFJsFuebiK6F2ccGgpubo+RPuv+Fw15iu6acchS1QvMwCUU2HRd42Xc54ILVwza1uWT3P+KKJtAH9igAYNb2siLa9W/zouqNvAMTt6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Qqe5MJiSqR1PBVzwd+cudDiMzceymzpnr+mZoC13gRo=;
 b=OqD7ACOeLeNU9PyEFPWjR52+e1IOeYYT8DxM2P1H3I6cczZvLpfzxzSRygVp1TDIxjtoFb7/5Mh0X4s8eHSQrrFFA7WaoOxp7sUwgFFCpC+DHymM1f2tgz7XOov5cQ5rTmPWkaJSyv4viRXoCuO9/MGuwoOFDU8xd9/1Cp5VRWh3g4M33jyEbS6Z7tdbCZUFx87I4sZatpAeJdulkK0k995DRQTstNKAcgQVhoy3xhJHSkrtd1CfWThpqHixLF27aEdZ/fElEJQdEfgOunYiDDtA+MVf9NdhwfDlwWzWsn8LvHoAopNbyeFS6cWoms7gaBBfGraBpfDj0PBQFDOW0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Qqe5MJiSqR1PBVzwd+cudDiMzceymzpnr+mZoC13gRo=;
 b=VNzaNBIVZ/5cw2lxNzcfJNpK1UAEocBb1goEPrrOy26NpH+EoegYrCs6ovxxVUoFDY5E8TVN6sfxIZ7BScfEiyA9njR87h54vwek4VQ0coEe7NCm/aa2/67UYEwDOpE8Tv37SxnJJMho4di9rJuGYr/A8AAuy+tZHfln3fJ0/po=
Authentication-Results: linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=none action=none
 header.from=oracle.com;
Received: from DM6PR10MB3851.namprd10.prod.outlook.com (2603:10b6:5:1fb::17)
 by DM6PR10MB4364.namprd10.prod.outlook.com (2603:10b6:5:223::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.23; Fri, 21 May
 2021 20:53:38 +0000
Received: from DM6PR10MB3851.namprd10.prod.outlook.com
 ([fe80::e490:f9ff:f8f3:c1e6]) by DM6PR10MB3851.namprd10.prod.outlook.com
 ([fe80::e490:f9ff:f8f3:c1e6%7]) with mapi id 15.20.4150.023; Fri, 21 May 2021
 20:53:38 +0000
From:   George Kennedy <george.kennedy@oracle.com>
To:     gregkh@linuxfoundation.org
Cc:     george.kennedy@oracle.com, stable@vger.kernel.org, daniel@ffwll.ch,
        airlied@linux.ie, maarten.lankhorst@linux.intel.com,
        mripard@kernel.org, robdclark@gmail.com, sean@poorly.run,
        tomi.valkeinen@ti.com, vegard.nossum@oracle.com,
        dhaval.giani@oracle.com, dan.carpenter@oracle.com,
        dvyukov@google.com
Subject: [PATCH 5.4.y 1/2] drm: Initialize struct drm_crtc_state.no_vblank from device settings
Date:   Fri, 21 May 2021 15:53:19 -0500
Message-Id: <1621630400-22972-2-git-send-email-george.kennedy@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1621630400-22972-1-git-send-email-george.kennedy@oracle.com>
References: <1621630400-22972-1-git-send-email-george.kennedy@oracle.com>
Content-Type: text/plain
X-Originating-IP: [209.17.40.39]
X-ClientProxiedBy: BYAPR07CA0078.namprd07.prod.outlook.com
 (2603:10b6:a03:12b::19) To DM6PR10MB3851.namprd10.prod.outlook.com
 (2603:10b6:5:1fb::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dhcp-10-152-13-169.usdhcp.oraclecorp.com.com (209.17.40.39) by BYAPR07CA0078.namprd07.prod.outlook.com (2603:10b6:a03:12b::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.23 via Frontend Transport; Fri, 21 May 2021 20:53:35 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b1395b22-a9ea-46c7-f6fc-08d91c9a81d1
X-MS-TrafficTypeDiagnostic: DM6PR10MB4364:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR10MB436433CAE5514C859741FE3EE6299@DM6PR10MB4364.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tbndPstdS/mCLPAI4eWnjx1rQAOHZTLabmfa94Zm2FoMJUsF/PBzuRt/EFZLSayzge3EXr3QCxVXxVChY81Qyu+hJJOf6KOLNXVuyboG4OSL087X6ZGhK6COTJ82L7uN8UDgDwBmi6SV3JFbotnUS4rvYSTwnbdLaPsDrT0QZeYlVGIqN/O/g0smiVQlJkzOHktjBGThPhUu683WC2Nit4fjYUMhYPdbDNheKmHpW+CYhh2w7ZYBDEhRXSTZVLsN3XBeB+FRDrrkvTfLv36eYbxeQ229OabdBfQN5HWt8mGj0M7aU7GncJMndgnU78S9/Fl4Wr2y8flwVYAa+2t3k0/bYULG3WtKWpgyc8TtDJphTOhCmXtJpw+X5lGcAeAv8LjWMORdnudNULzdzDjDZeeX1ZV9M/g2+8LfCLzgLXTLFv6qepVgjRy/dVJCMgtk8Dhpvl6LMeFyCuIKFseWYd2iZtaEmAFYl4aYACVxcEI2WsC0XCXBg0ohf44zuyzw+afz/H0EVZ9jUB3qYMaglZlwivgW93KQEsnKNiuCxae8ml91/Z4OiFl9k1sXrsp1XG9i7Ey1zvkCufQN7lWA9Sbrm6IPizvDREPao7LJVk6FzMF4X8hEupe+5r7roa5ePX4dTrJlM1AyTi950So/7RmrfNkFTHSpUlxfSxv40SW36DXZjjLfMGOhPzoUxLNB
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB3851.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(346002)(396003)(39860400002)(366004)(376002)(38350700002)(7416002)(6486002)(38100700002)(6512007)(6916009)(6506007)(83380400001)(36756003)(316002)(4326008)(44832011)(186003)(6666004)(66556008)(66946007)(66476007)(2616005)(2906002)(16526019)(8676002)(966005)(8936002)(956004)(52116002)(5660300002)(86362001)(478600001)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?h+i5h7NLbbGB+m3lNzKSl/XpeUqrIVmDqBl9nesTXYhmC9Lxua8L0YZFFmYP?=
 =?us-ascii?Q?taoLsFiR0HHcfZMjn5aYMKTDy1vx6qklKiVtGIHmZ39dc3qC4WeKY4h499Vf?=
 =?us-ascii?Q?AM1Lz3rU39z1tesl7nHOEmOrikdWcNGVUrp0dJwyE5MSHELVsRu4ejLZUVSs?=
 =?us-ascii?Q?ucC83DxGkFZxc+Ucu1/oYmHJONJMrr13L+EAVxsRSRYzbodndDKxFfSZBSsl?=
 =?us-ascii?Q?NleqGB1c3LwYM4KnYqkVXkMhY2GiPkqevY04Lx106E4Ah28rsEY3P9rjhnlI?=
 =?us-ascii?Q?Z6vePL+akhKlDLlXcKlxYsDfrXv7HnfjoXM1UAphFkbmWyNwgW8cr8V/Fl1c?=
 =?us-ascii?Q?x4tuoSCHR77W2tMCjzWYEblLy2qe4MRSe0Wh8vamp8lWgbDuRurNHXO4QBEF?=
 =?us-ascii?Q?7eCgbnfT+lsmnMJuCx3nsLSRGMgw3egAbvETFgBaKnFvZxj9GeXGt0PnDBH/?=
 =?us-ascii?Q?5A/9VAG47wIkG2JDJK0aWuyaig4b3C2i88KuK8EWL98M8rGqx6tk5zlxkhMx?=
 =?us-ascii?Q?R5JZ84FEjeE95S05L7tQdpZw+qh/EnPP0G3BjHDWsfafc7vYvrsE3s+m8zC7?=
 =?us-ascii?Q?zc4AHSEmXjtbRmjdtszf09fggGz+okF8Qtp7FnNmrbuGWVL9N3uI6sEWP4Be?=
 =?us-ascii?Q?dNJznwce3GOUQp+Drq0AnQYtu0OZzVPr0GyaY5Mhew2Ej1srhzXR90uoRFqq?=
 =?us-ascii?Q?umdsXNrAFgbF+wqPHQLQBT0Xaff8bAmSXnmCZCj0thHUg9Qh2nibM3C2I4ul?=
 =?us-ascii?Q?LBDeB80O98rXyLmqafcQW7cZB/9ZsVI/T+oYKiaLt6zZX8qYCCNf6l0wqxsa?=
 =?us-ascii?Q?CXjvu3iXYJ3omDM24z1OHFsxWLNlrDeO4trT+BzJydAzbt9qsVvZyUn0osI8?=
 =?us-ascii?Q?plzTCabe0Ad5MPwwvEfdAZtquQyVrpV19lEKNXQjlzxaUPYTpxSeBKL4T0VR?=
 =?us-ascii?Q?ncdtlrWutrM6YpubAhj4VQWtn26Sg0sHcPtFpy45qGWwqPniDS2/P2JN9krQ?=
 =?us-ascii?Q?9h197WMY1wYzWAoht37ApLn5YtRPj2gywp5m3KtOWTei2v9BapyVYSkNlhxU?=
 =?us-ascii?Q?N6baYZ/668O7+b8T270IcqZ8slS3nu+1HNCbjqVodFTWx8w2N1s4hpNbcgN0?=
 =?us-ascii?Q?VKxGvTRHBtDlj9MrIEkr/Wd4BwxNeuRDY+SiFN1zYaCUTvZ3IKXScLRfW4zC?=
 =?us-ascii?Q?JzOoqsSA+/1TbAENAcc7esefdym1LFW4F52xJ+1KBMZhRTQlMJrJwYwGaswk?=
 =?us-ascii?Q?z+CIHEBkvDWq7UNCjkJvoPHZ6PeefkD984D//DdYoRmCgRis/8ZR0OGMaXpT?=
 =?us-ascii?Q?nOWEXGhaQsBwZUa8k7YHsvRq?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b1395b22-a9ea-46c7-f6fc-08d91c9a81d1
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB3851.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 May 2021 20:53:37.9387
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eMJMShjWLwAMpdj//GlVa8LxGG1RXf+GPyQ4Tr865FC3JVfyozIOLOjUIKBm7GiGoYrHCE2eGkeUmRehi/wGKBGw5aB77dO5mwSASrPgjgE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4364
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9991 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 adultscore=0
 phishscore=0 malwarescore=0 bulkscore=0 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105210113
X-Proofpoint-GUID: lMojeWJfE2p3UkAcAMJChmSp5DgspwJH
X-Proofpoint-ORIG-GUID: lMojeWJfE2p3UkAcAMJChmSp5DgspwJH
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Zimmermann <tzimmermann@suse.de>

At the end of a commit, atomic helpers can generate a fake VBLANK event
automatically. Originally implemented for writeback connectors, the
functionality can be used by any driver and/or hardware without proper
VBLANK interrupt.

The patch updates the documentation to make this behaviour official:
settings struct drm_crtc_state.no_vblank to true enables automatic
generation of fake VBLANK events.

The new interface drm_dev_has_vblank() returns true if vblanking has
been initialized for a device, or false otherwise. Atomic helpers use
this function when initializing no_vblank in the CRTC state in
drm_atomic_helper_check_modeset(). If vblanking has been initialized
for a device, no_blank is disabled. Otherwise it's enabled. Hence,
atomic helpers will automatically send out fake VBLANK events with any
driver that did not initialize vblanking.

v5:
	* more precise documentation and commit message
v4:
	* replace drm_crtc_has_vblank() with drm_dev_has_vblank()
	* add drm_dev_has_vblank() in this patch
	* move driver changes into separate patches
v3:
	* squash all related changes patches into this patch

Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Acked-by: Gerd Hoffmann <kraxel@redhat.com>
Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Link: https://patchwork.freedesktop.org/patch/msgid/20200129120531.6891-2-tzimmermann@suse.de
(cherry picked from commit 7beb691f1e6f349c9df3384a85e7a53c5601aaaf)
Signed-off-by: George Kennedy <george.kennedy@oracle.com>
---
 drivers/gpu/drm/drm_atomic_helper.c | 10 +++++++++-
 drivers/gpu/drm/drm_vblank.c        | 28 ++++++++++++++++++++++++++++
 include/drm/drm_crtc.h              | 34 +++++++++++++++++++++++++++-------
 include/drm/drm_simple_kms_helper.h |  7 +++++--
 include/drm/drm_vblank.h            |  1 +
 5 files changed, 70 insertions(+), 10 deletions(-)

diff --git a/drivers/gpu/drm/drm_atomic_helper.c b/drivers/gpu/drm/drm_atomic_helper.c
index 5e906ea..9a5eb76 100644
--- a/drivers/gpu/drm/drm_atomic_helper.c
+++ b/drivers/gpu/drm/drm_atomic_helper.c
@@ -588,6 +588,7 @@ static enum drm_mode_status mode_valid_path(struct drm_connector *connector,
  * &drm_crtc_state.connectors_changed is set when a connector is added or
  * removed from the crtc.  &drm_crtc_state.active_changed is set when
  * &drm_crtc_state.active changes, which is used for DPMS.
+ * &drm_crtc_state.no_vblank is set from the result of drm_dev_has_vblank().
  * See also: drm_atomic_crtc_needs_modeset()
  *
  * IMPORTANT:
@@ -654,6 +655,11 @@ static enum drm_mode_status mode_valid_path(struct drm_connector *connector,
 
 			return -EINVAL;
 		}
+
+		if (drm_dev_has_vblank(dev))
+			new_crtc_state->no_vblank = false;
+		else
+			new_crtc_state->no_vblank = true;
 	}
 
 	ret = handle_conflicting_encoders(state, false);
@@ -2202,7 +2208,9 @@ void drm_atomic_helper_wait_for_dependencies(struct drm_atomic_state *old_state)
  * when a job is queued, and any change to the pipeline that does not touch the
  * connector is leading to timeouts when calling
  * drm_atomic_helper_wait_for_vblanks() or
- * drm_atomic_helper_wait_for_flip_done().
+ * drm_atomic_helper_wait_for_flip_done(). In addition to writeback
+ * connectors, this function can also fake VBLANK events for CRTCs without
+ * VBLANK interrupt.
  *
  * This is part of the atomic helper support for nonblocking commits, see
  * drm_atomic_helper_setup_commit() for an overview.
diff --git a/drivers/gpu/drm/drm_vblank.c b/drivers/gpu/drm/drm_vblank.c
index 552ec82..c98ed814 100644
--- a/drivers/gpu/drm/drm_vblank.c
+++ b/drivers/gpu/drm/drm_vblank.c
@@ -69,6 +69,12 @@
  * &drm_driver.max_vblank_count. In that case the vblank core only disables the
  * vblanks after a timer has expired, which can be configured through the
  * ``vblankoffdelay`` module parameter.
+ *
+ * Drivers for hardware without support for vertical-blanking interrupts
+ * must not call drm_vblank_init(). For such drivers, atomic helpers will
+ * automatically generate fake vblank events as part of the display update.
+ * This functionality also can be controlled by the driver by enabling and
+ * disabling struct drm_crtc_state.no_vblank.
  */
 
 /* Retry timestamp calculation up to 3 times to satisfy
@@ -489,6 +495,28 @@ int drm_vblank_init(struct drm_device *dev, unsigned int num_crtcs)
 EXPORT_SYMBOL(drm_vblank_init);
 
 /**
+ * drm_dev_has_vblank - test if vblanking has been initialized for
+ *                      a device
+ * @dev: the device
+ *
+ * Drivers may call this function to test if vblank support is
+ * initialized for a device. For most hardware this means that vblanking
+ * can also be enabled.
+ *
+ * Atomic helpers use this function to initialize
+ * &drm_crtc_state.no_vblank. See also drm_atomic_helper_check_modeset().
+ *
+ * Returns:
+ * True if vblanking has been initialized for the given device, false
+ * otherwise.
+ */
+bool drm_dev_has_vblank(const struct drm_device *dev)
+{
+	return dev->num_crtcs != 0;
+}
+EXPORT_SYMBOL(drm_dev_has_vblank);
+
+/**
  * drm_crtc_vblank_waitqueue - get vblank waitqueue for the CRTC
  * @crtc: which CRTC's vblank waitqueue to retrieve
  *
diff --git a/include/drm/drm_crtc.h b/include/drm/drm_crtc.h
index 408b6f4..ebcce95 100644
--- a/include/drm/drm_crtc.h
+++ b/include/drm/drm_crtc.h
@@ -175,12 +175,25 @@ struct drm_crtc_state {
 	 * @no_vblank:
 	 *
 	 * Reflects the ability of a CRTC to send VBLANK events. This state
-	 * usually depends on the pipeline configuration, and the main usuage
-	 * is CRTCs feeding a writeback connector operating in oneshot mode.
-	 * In this case the VBLANK event is only generated when a job is queued
-	 * to the writeback connector, and we want the core to fake VBLANK
-	 * events when this part of the pipeline hasn't changed but others had
-	 * or when the CRTC and connectors are being disabled.
+	 * usually depends on the pipeline configuration. If set to true, DRM
+	 * atomic helpers will send out a fake VBLANK event during display
+	 * updates after all hardware changes have been committed. This is
+	 * implemented in drm_atomic_helper_fake_vblank().
+	 *
+	 * One usage is for drivers and/or hardware without support for VBLANK
+	 * interrupts. Such drivers typically do not initialize vblanking
+	 * (i.e., call drm_vblank_init() with the number of CRTCs). For CRTCs
+	 * without initialized vblanking, this field is set to true in
+	 * drm_atomic_helper_check_modeset(), and a fake VBLANK event will be
+	 * send out on each update of the display pipeline by
+	 * drm_atomic_helper_fake_vblank().
+	 *
+	 * Another usage is CRTCs feeding a writeback connector operating in
+	 * oneshot mode. In this case the fake VBLANK event is only generated
+	 * when a job is queued to the writeback connector, and we want the
+	 * core to fake VBLANK events when this part of the pipeline hasn't
+	 * changed but others had or when the CRTC and connectors are being
+	 * disabled.
 	 *
 	 * __drm_atomic_helper_crtc_duplicate_state() will not reset the value
 	 * from the current state, the CRTC driver is then responsible for
@@ -336,7 +349,14 @@ struct drm_crtc_state {
 	 *  - Events for disabled CRTCs are not allowed, and drivers can ignore
 	 *    that case.
 	 *
-	 * This can be handled by the drm_crtc_send_vblank_event() function,
+	 * For very simple hardware without VBLANK interrupt, enabling
+	 * &struct drm_crtc_state.no_vblank makes DRM's atomic commit helpers
+	 * send a fake VBLANK event at the end of the display update after all
+	 * hardware changes have been applied. See
+	 * drm_atomic_helper_fake_vblank().
+	 *
+	 * For more complex hardware this
+	 * can be handled by the drm_crtc_send_vblank_event() function,
 	 * which the driver should call on the provided event upon completion of
 	 * the atomic commit. Note that if the driver supports vblank signalling
 	 * and timestamping the vblank counters and timestamps must agree with
diff --git a/include/drm/drm_simple_kms_helper.h b/include/drm/drm_simple_kms_helper.h
index 4d89cd0..df615eb 100644
--- a/include/drm/drm_simple_kms_helper.h
+++ b/include/drm/drm_simple_kms_helper.h
@@ -100,8 +100,11 @@ struct drm_simple_display_pipe_funcs {
 	 * This is the function drivers should submit the
 	 * &drm_pending_vblank_event from. Using either
 	 * drm_crtc_arm_vblank_event(), when the driver supports vblank
-	 * interrupt handling, or drm_crtc_send_vblank_event() directly in case
-	 * the hardware lacks vblank support entirely.
+	 * interrupt handling, or drm_crtc_send_vblank_event() for more
+	 * complex case. In case the hardware lacks vblank support entirely,
+	 * drivers can set &struct drm_crtc_state.no_vblank in
+	 * &struct drm_simple_display_pipe_funcs.check and let DRM's
+	 * atomic helper fake a vblank event.
 	 */
 	void (*update)(struct drm_simple_display_pipe *pipe,
 		       struct drm_plane_state *old_plane_state);
diff --git a/include/drm/drm_vblank.h b/include/drm/drm_vblank.h
index 9fe4ba8..2559fb9 100644
--- a/include/drm/drm_vblank.h
+++ b/include/drm/drm_vblank.h
@@ -195,6 +195,7 @@ struct drm_vblank_crtc {
 };
 
 int drm_vblank_init(struct drm_device *dev, unsigned int num_crtcs);
+bool drm_dev_has_vblank(const struct drm_device *dev);
 u64 drm_crtc_vblank_count(struct drm_crtc *crtc);
 u64 drm_crtc_vblank_count_and_time(struct drm_crtc *crtc,
 				   ktime_t *vblanktime);
-- 
1.8.3.1

