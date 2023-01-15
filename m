Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9472E66B4DD
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 00:58:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231593AbjAOX6P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 15 Jan 2023 18:58:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231652AbjAOX6O (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 15 Jan 2023 18:58:14 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E243CC27
        for <stable@vger.kernel.org>; Sun, 15 Jan 2023 15:58:13 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QNlK+111SOsxWUR98U1o6Or+xHf3klK86tqxS74olLb7885mSOzLUw+6T0ffvu6Dw3+owTdX9l747x7Xg71FG/3+yg5rOXThgdyBsxlezBABK2tfDRS2NBOkny+cuw2y7HnYk6FTSJkAUOkxGp9qWhhQIkkE97vLUjXqkc4wZ/o+wyOGRYXzvkqn5IbIFFC9zi0ZGdnouM+tIg0+lb5BXxPNRXK57DXLBBKC3wrxc3pBd9O+JfIRhR8X25bXgoBjZvttFcwgA04zwThwl71VdOU2afFhY8zmSIFQbk5noS20tHeI8WHcxtWSMcidzCdvaT91JUxINCRdKYYotyLbIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zjuJMZvfy59iIqtmcrbbcQWBj19W8pRsLHkDKZ4q25k=;
 b=kj/f5h7fB0WL64UsrM1l+/GqjcwdhWirRy1ppEwTvT2Z1HPUsRiIqUx5VhjUe3bQwhnSi3/u4/3V+P2cizZaxBb+VClU8D+1SI2LSmQSmJRlRHqigk+1TRKZnusiKf1S7pPk+lD7NbzEgFU0upA/s2PZ5Zi+HAyRBHRYWx/YVAmaa+fQhHTn9Qd+IAfQoYl4vndMTl9NiiOPa5BcnRtUXHW8JLKbEGtfma0NQZIFz4zFtFYrrAfp0oL2mCjLhsNkP1YUgkLNlLMRZsWIMs7+OT1JFAf2mMZK5lZ1sgPu5rlYemnLlv7umwrArgaYUadMWbsicMYV7+RJdTILYNO6Eg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zjuJMZvfy59iIqtmcrbbcQWBj19W8pRsLHkDKZ4q25k=;
 b=DdLluEcqUAFClhmw7AEg/Jr14RIZUQ87FauS/Plf2iW6o48GGoKqfxNu1HuTtd9GND23emSb+rMzfGy7pV8qgS1BgS5Kz7Ha5k4imr3jaVE9nKEEtpkStNwWhpfpDnQInsZyopLSDAyyjzo9kNhTKhpLlXSp67WJ2UY19lOXWBY=
Received: from DM5PR12MB2469.namprd12.prod.outlook.com (2603:10b6:4:af::38) by
 BY5PR12MB4257.namprd12.prod.outlook.com (2603:10b6:a03:20f::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.13; Sun, 15 Jan
 2023 23:58:11 +0000
Received: from DM5PR12MB2469.namprd12.prod.outlook.com
 ([fe80::d068:807d:11c:eee0]) by DM5PR12MB2469.namprd12.prod.outlook.com
 ([fe80::d068:807d:11c:eee0%5]) with mapi id 15.20.5986.023; Sun, 15 Jan 2023
 23:58:02 +0000
From:   "Chen, Guchun" <Guchun.Chen@amd.com>
To:     "Deucher, Alexander" <Alexander.Deucher@amd.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
CC:     Sasha Levin <sashal@kernel.org>,
        Yury Zhuravlev <stalkerg@gmail.com>,
        "Song, Asher" <Asher.Song@amd.com>
Subject: RE: [PATCH] Revert "drm/amdgpu: Revert "drm/amdgpu: getting fan speed
 pwm for vega10 properly""
Thread-Topic: [PATCH] Revert "drm/amdgpu: Revert "drm/amdgpu: getting fan
 speed pwm for vega10 properly""
Thread-Index: AQHZJ4G2DKARdMkVykmzDAxCzmefAa6gKzlg
Date:   Sun, 15 Jan 2023 23:58:02 +0000
Message-ID: <DM5PR12MB24696B26DD96D2F70F99E887F1C09@DM5PR12MB2469.namprd12.prod.outlook.com>
References: <20230113190302.2210187-1-alexander.deucher@amd.com>
In-Reply-To: <20230113190302.2210187-1-alexander.deucher@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM5PR12MB2469:EE_|BY5PR12MB4257:EE_
x-ms-office365-filtering-correlation-id: 10206206-8442-4d0e-1003-08daf754562b
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Y0BT9P3z3vvsoawzZ2hUCoXxZg6J19yQqYMy9q4C1YqpJ0/9nvtJqhdTD+JQnUI7k1xPFLI0vENzHf0mOcz0VEO7GM11CSDydzLE8caHYVpdbNpRhrZxzKWLjbJblPi4X8SyL9qY+i10w0ac9CoF1i2zHE6ah//OF0v/NockrdBwFDfdCAOusAzY4N7r4UaXOii2sLvnzs7Cq36EbZ7m+m9B1gUzx8/t6WExLR1cJ48o09hWe/q9FlGZEOeVPbefZFH8gy4II/F8mK8aBdm+tRSe4Pt2zCAYHddEMpF4IpwSlEydcFFHBW7eYYJSP9Tj0By9pa5CxcJPMm9xH2l4j9KfDOtS1Dey5maS5KZgWlvehm2xlmYji3Xyer0SRBGoSa4UpADNombjIFjYOPiT5v1pl1toCNb/Wh2KT7JsEonYabsTniTSI//t99oBuid7m5Oj91xKhPNANzhMGfSOSo8U9pt9DY1WscNuTFfpUVUKvmYnqAEjFe7qC16E8cLypZ0gmToDQlEeN7VjTt+OZ7BrWwlxTYHMOtr3I1mVki+p2ilLZFKu6VNq6toRuTKHCpnFdcrAjbpYaQPyCEUzet9qDfiLE3/t95kQ5beL/+GAxKUMGIeww+c8vVq+rc25HJZ1xwmBwfOb/iZvpEWiqu7UXjzzT89y1OdZeIBxmFwHDLT2NWcM3JTcCXrN0/sMyESW/LyLdKSmn0SXTO1AtQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB2469.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(39850400004)(376002)(136003)(366004)(346002)(451199015)(33656002)(38100700002)(122000001)(71200400001)(76116006)(8676002)(4326008)(186003)(55016003)(86362001)(26005)(9686003)(316002)(66946007)(38070700005)(66476007)(66446008)(110136005)(478600001)(64756008)(54906003)(7696005)(5660300002)(8936002)(52536014)(41300700001)(2906002)(6506007)(66556008)(83380400001)(53546011);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?2f76jh8tMFZ1hVrsrxtSPd2yptizWEOu9irO8GKOuVYmjqmRStI4fJsXEIMg?=
 =?us-ascii?Q?O5R7RqVqisalVeXCw5Onei52x4q0rifRxxCQRFQbZ3a6s195BQ9cl0AnlPuX?=
 =?us-ascii?Q?VsszvUU1ZnjUjA+adj7KMtLF9BE4C9DLlQ8pfnQeZk6g/nHGnlCgrNl4m3q1?=
 =?us-ascii?Q?ZnZIDtREzNi+XAzxnCAmOstwiwensFKzefWWbY9y53upmaO6/zEzj/Mc3IdC?=
 =?us-ascii?Q?l+3FRJQ+7CtIb950IJ1bsSQ5Pn8F9bWEBx1gOruNZ9YeaSEBqEYBnvUks3CR?=
 =?us-ascii?Q?RuZ+wdrkf0hTGhqs5q7y6y5WABWrqh8YCG2HapHqcxowFrReVW1NDh0nqkzZ?=
 =?us-ascii?Q?tZJGjF+NPo0vzuoU8mZXAZ0ypS6kkKS8kUJqkXgW0J+a1IiukFyJ6WJLlm3T?=
 =?us-ascii?Q?JLfnFmTIMadQyl2ju3aedYxjmnnvRJdWOE+/m2a5oHngPLwbzBcjfnpdS9nt?=
 =?us-ascii?Q?3699FdSko7UOTWf4T2L5xZ19OqekI06w+Z69jFw5VjPBeo38dvhQQM8wpkbD?=
 =?us-ascii?Q?qKwdZSiH3fZfT9++LR4NtHnJ8k+0YCUQ9cEOjdDK3O1iSehTJ2sBAT+SWUCy?=
 =?us-ascii?Q?GE+simvy1e/FfM6GH8tU1Jp8F0k9he2Tz/ANun/73mehMzLOfPUyQohJ77Gi?=
 =?us-ascii?Q?F7+3ZwKNBxv/+J0CZ9CPSq0Cme3UbgwazD7D+xFDeKcIwCD+Lz8zkIJzKc6n?=
 =?us-ascii?Q?32iKfg7nFPjSV2w+3PaBYplfo3ax2zdBWNcd3DgF7XUN9sBnJJqMYxT0LY4q?=
 =?us-ascii?Q?rewq5Yf2m3/Lw9aTA3wjcU7OwobXjzXE2W7ctKWLDB9GqAVdg2OxUfnm8m8G?=
 =?us-ascii?Q?a9Hy84L5oSbOVubp6sy6I1SmPLwRt+T8xKd8Imlg5co0uwxL6tCdOj1uiCSd?=
 =?us-ascii?Q?YZLHW5E18BsMw7f1rxMvmOYBhBKMP6Cff7RH+UvlIKQqSfFtOPr5H2fa2hcx?=
 =?us-ascii?Q?omtqtO48MfZ1laLDjCNZ3kn6/JbxnO44gK3LsDBypp2UEIJAw2Gsfmezy2ad?=
 =?us-ascii?Q?NxSo8AeJbyhbJVq/JZYTFwCZRd/tUD+r656TWXd1RH0jT5rVCw/CulBOoCO5?=
 =?us-ascii?Q?ofssB6NqoiUW37TqBbSpKI7spiIJknNvT7m4y1uXZu9M6JgZ6/N+ir4M30dA?=
 =?us-ascii?Q?h/Vu9m33yh5jNU9Ba72onU3xrvW6cqV5WvbNhN8oh3Uq3Le5lztU2+MIbRUq?=
 =?us-ascii?Q?IWQQLqrpXAsSiZBRRgc8GX4WNmhhHhZM8XHucsbN82jnF5W4RfdVolSjq7oj?=
 =?us-ascii?Q?RvrsqMWmW5iP4tgyW0lLMNELgx0W32+AwlKpr/R9C63sMZGvjOj+5zkC1SJu?=
 =?us-ascii?Q?s5HuFjGy8c+TqQRzlC+i9rDPNCDO5TscJxYLLcKQws46+lCFsFspUjmdOGpF?=
 =?us-ascii?Q?ax8VOjDHSe5Rl98KBIDjfeMm7M8ekNcwj2CnQZ3MK0OCfx9u+Bx+4X/TyHHn?=
 =?us-ascii?Q?1Bv530p0BNQ51F/t7j7PSPoHPwtQtVV6fQ4TzBBJF8cz0Vda9tGhvN6OSE+7?=
 =?us-ascii?Q?rVO6KRddMmgJjW5bDGl+7jb1mxfcbuVAu77qfD7vGxthrubTvGfl98+GC+QU?=
 =?us-ascii?Q?GC+ZZBcaxc1yUqrS533ECrn/9dTRhrBTfWo9JP94?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB2469.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 10206206-8442-4d0e-1003-08daf754562b
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jan 2023 23:58:02.1010
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: r79ScVxk3RAPBgkqsoon4dn9CdeXo3Tp+8jE6ZFjxodjUzlfauULdQC+D9Dkd1sk2B2BnLGiO+0+tHykPj3WXQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4257
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Reviewed-by: Guchun Chen <guchun.chen@amd.com>

Regards,
Guchun

-----Original Message-----
From: Deucher, Alexander <Alexander.Deucher@amd.com>=20
Sent: Saturday, January 14, 2023 3:03 AM
To: gregkh@linuxfoundation.org; stable@vger.kernel.org
Cc: Deucher, Alexander <Alexander.Deucher@amd.com>; Sasha Levin <sashal@ker=
nel.org>; Yury Zhuravlev <stalkerg@gmail.com>; Chen, Guchun <Guchun.Chen@am=
d.com>; Song, Asher <Asher.Song@amd.com>
Subject: [PATCH] Revert "drm/amdgpu: Revert "drm/amdgpu: getting fan speed =
pwm for vega10 properly""

This reverts commit 9ccd11718d76b95c69aa773f2abedef560776037.

The original commit 16fb4dca95daa ("drm/amdgpu: getting fan speed pwm for v=
ega10 properly") was reverted in commit 4545ae2ed3f2 ("drm/amdgpu: Revert "=
drm/amdgpu: getting fan speed pwm for vega10 properly"").
but the test that resulted in the revert was wrong and was fixed so the rev=
ert was reverted in commit 30b8e7b8ee3b ("Revert "drm/amdgpu: Revert "drm/a=
mdgpu: getting fan speed pwm for vega10 properly""").
That should have been the end of it, but then Sasha picked up the original =
revert again and it was committed as 9ccd11718d76.  So drop that commit so =
we get back to where we need to be.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: Sasha Levin <sashal@kernel.org>
Cc: stable@vger.kernel.org # 6.1.x
Cc: Yury Zhuravlev <stalkerg@gmail.com>
Cc: Guchun Chen <guchun.chen@amd.com>
Cc: Asher Song <Asher.Song@amd.com>
---
 .../amd/pm/powerplay/hwmgr/vega10_thermal.c   | 25 +++++++++----------
 1 file changed, 12 insertions(+), 13 deletions(-)

diff --git a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega10_thermal.c b/driv=
ers/gpu/drm/amd/pm/powerplay/hwmgr/vega10_thermal.c
index dad3e3741a4e..190af79f3236 100644
--- a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega10_thermal.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega10_thermal.c
@@ -67,22 +67,21 @@ int vega10_fan_ctrl_get_fan_speed_info(struct pp_hwmgr =
*hwmgr,  int vega10_fan_ctrl_get_fan_speed_pwm(struct pp_hwmgr *hwmgr,
 		uint32_t *speed)
 {
-	uint32_t current_rpm;
-	uint32_t percent =3D 0;
-
-	if (hwmgr->thermal_controller.fanInfo.bNoFan)
-		return 0;
+	struct amdgpu_device *adev =3D hwmgr->adev;
+	uint32_t duty100, duty;
+	uint64_t tmp64;
=20
-	if (vega10_get_current_rpm(hwmgr, &current_rpm))
-		return -1;
+	duty100 =3D REG_GET_FIELD(RREG32_SOC15(THM, 0, mmCG_FDO_CTRL1),
+				CG_FDO_CTRL1, FMAX_DUTY100);
+	duty =3D REG_GET_FIELD(RREG32_SOC15(THM, 0, mmCG_THERMAL_STATUS),
+				CG_THERMAL_STATUS, FDO_PWM_DUTY);
=20
-	if (hwmgr->thermal_controller.
-			advanceFanControlParameters.usMaxFanRPM !=3D 0)
-		percent =3D current_rpm * 255 /
-			hwmgr->thermal_controller.
-			advanceFanControlParameters.usMaxFanRPM;
+	if (!duty100)
+		return -EINVAL;
=20
-	*speed =3D MIN(percent, 255);
+	tmp64 =3D (uint64_t)duty * 255;
+	do_div(tmp64, duty100);
+	*speed =3D MIN((uint32_t)tmp64, 255);
=20
 	return 0;
 }
--
2.39.0

