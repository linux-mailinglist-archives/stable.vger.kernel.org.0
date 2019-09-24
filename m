Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E639BC82E
	for <lists+stable@lfdr.de>; Tue, 24 Sep 2019 14:50:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395394AbfIXMuF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Sep 2019 08:50:05 -0400
Received: from mx0b-00128a01.pphosted.com ([148.163.139.77]:28286 "EHLO
        mx0b-00128a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2395292AbfIXMuF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Sep 2019 08:50:05 -0400
Received: from pps.filterd (m0167091.ppops.net [127.0.0.1])
        by mx0b-00128a01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x8OCbvd2018884;
        Tue, 24 Sep 2019 08:49:32 -0400
Received: from nam04-co1-obe.outbound.protection.outlook.com (mail-co1nam04lp2057.outbound.protection.outlook.com [104.47.45.57])
        by mx0b-00128a01.pphosted.com with ESMTP id 2v6hku1ty5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 24 Sep 2019 08:49:32 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n4avZnQmEHIMIVnfZ6swkamPZ8rDDjxB02azZJv2xWrUTlLt96vwQNvDPqsPUj66/Edi7O7yrK69k69CG24pXxCXlS3vW4NnuinPkeMZZVhF7EcePChRigKVNrmdrAUl61yVeeaI3cdwXMcrTh12DHnXP0EctUuu4TCM8cxtH9x/gNrmxuR0bY9ht9L9/CRYpxn+lcoMYf11ROfEnvNA/HVxRtnMNKIMS5H8On7dElcS+EnaqR1xJRGEqgDYQcerJEabb1yFxdzr++pKTMO3tLwdbI66TpWwSWBo4wy+sT/UZiuQzk4AyOxnxqPt1OF4APGLDdZfRLA5MagT4/dtHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X8COh3mGDSbBD6jh6UYIp/S7oKbpJyJ0Y3T5ITKZNDg=;
 b=LB8x8jkEFVKjzVF289lbw7w+KMFnOgL2myEhE94v0icP7XRcxDc0y+yqeVHvnDxnBHuzR3F48+sjCnZpyjw8Akf6OGlmHURKPPIpMuBC3yHcqUF5l25ZSS+MH9Q5vAFkyl8xUtcPhwvS5F0cwvEUrcjBdFai0MvHv8LA1MLZfYTesq/Ozi9VNxFuksuQJAh184ILgdTyjSSraaTeQj7ukX6I+QoIDVKEllNJJsSQzHDRiNo56wjsDtLRVDLFu6dsFh5nEMvq+sNWjdmFtwCiD0qeXco3t4SJcxBFJDrh834KimpU8L1D7QEC3IKkkrzZXUoGuw35E28CjEVlDOmy7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 137.71.25.55) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=analog.com;
 dmarc=bestguesspass action=none header.from=analog.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=analog.onmicrosoft.com; s=selector2-analog-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X8COh3mGDSbBD6jh6UYIp/S7oKbpJyJ0Y3T5ITKZNDg=;
 b=wLT5METfXlSZ4TycyLL30bqg4jpc2M3NP7TzyuZdkrCjL1vbgzTqcOrU6Mlq8zdn3+JUc/xtcjjkYKpAkH2LTzQWQE2MY7Wl+y8e63DQgf5H25hU5kxaAg8y2a6tTamp4bI7Ct9/K7+S0xZGkCkGymdPqWXLGlOnurUDZl+K7f0=
Received: from CH2PR03CA0027.namprd03.prod.outlook.com (2603:10b6:610:59::37)
 by BN7PR03MB3651.namprd03.prod.outlook.com (2603:10b6:406:cb::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2284.20; Tue, 24 Sep
 2019 12:49:30 +0000
Received: from SN1NAM02FT035.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e44::207) by CH2PR03CA0027.outlook.office365.com
 (2603:10b6:610:59::37) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2284.20 via Frontend
 Transport; Tue, 24 Sep 2019 12:49:30 +0000
Received-SPF: Pass (protection.outlook.com: domain of analog.com designates
 137.71.25.55 as permitted sender) receiver=protection.outlook.com;
 client-ip=137.71.25.55; helo=nwd2mta1.analog.com;
Received: from nwd2mta1.analog.com (137.71.25.55) by
 SN1NAM02FT035.mail.protection.outlook.com (10.152.72.145) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2284.25
 via Frontend Transport; Tue, 24 Sep 2019 12:49:29 +0000
Received: from NWD2HUBCAS7.ad.analog.com (nwd2hubcas7.ad.analog.com [10.64.69.107])
        by nwd2mta1.analog.com (8.13.8/8.13.8) with ESMTP id x8OCnOoj020595
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Tue, 24 Sep 2019 05:49:24 -0700
Received: from nsa.sphairon.box (10.44.3.90) by NWD2HUBCAS7.ad.analog.com
 (10.64.69.107) with Microsoft SMTP Server (TLS) id 14.3.408.0; Tue, 24 Sep
 2019 08:49:29 -0400
From:   =?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>
To:     <linux-hwmon@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>
CC:     Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Jean Delvare <jdelvare@suse.com>,
        Jonathan Corbet <corbet@lwn.net>, <stable@vger.kernel.org>
Subject: [PATCH 1/3] hwmon: Fix HWMON_P_MIN_ALARM mask
Date:   Tue, 24 Sep 2019 14:49:43 +0200
Message-ID: <20190924124945.491326-2-nuno.sa@analog.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190924124945.491326-1-nuno.sa@analog.com>
References: <20190924124945.491326-1-nuno.sa@analog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.44.3.90]
X-ADIRoutedOnPrem: True
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:137.71.25.55;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(396003)(39840400004)(136003)(376002)(346002)(199004)(189003)(106002)(50226002)(2906002)(246002)(2616005)(476003)(45776006)(336012)(486006)(126002)(8676002)(11346002)(426003)(53416004)(26005)(23676004)(305945005)(4326008)(316002)(446003)(110136005)(186003)(8936002)(16526019)(54906003)(50466002)(86362001)(2201001)(3846002)(6116002)(7636002)(76176011)(47776003)(7736002)(478600001)(5660300002)(356004)(6666004)(36756003)(5820100001)(1076003)(14444005)(70206006)(4744005)(2870700001)(70586007);DIR:OUT;SFP:1101;SCL:1;SRVR:BN7PR03MB3651;H:nwd2mta1.analog.com;FPR:;SPF:Pass;LANG:en;PTR:nwd2mail10.analog.com;A:1;MX:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ad4e4a4b-0fb9-4ec1-7fa2-08d740eda421
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600167)(711020)(4605104)(4709080)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:BN7PR03MB3651;
X-MS-TrafficTypeDiagnostic: BN7PR03MB3651:
X-Microsoft-Antispam-PRVS: <BN7PR03MB3651B584031D6306D3842A1499840@BN7PR03MB3651.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1079;
X-Forefront-PRVS: 0170DAF08C
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: KF3C7AyPvRJOpEwIIUWioBv8dF2a+qbeEBhAqLG9uvMZ2qMdfDCHt5R5qlFh+Z7BICp1tyF9KRnn1wi5fJUNW/UpikA0Jh+fQtlSVxGDvYbTTIQnnqMGaNywnHgnhqRSPuWP/fpq4VhYXmcnWuaPJY3ee842YdnAQl2uQH291VVylcgxpmLzqnVj1493KpbbUSz00OBjphU3zdyuW/YdGCLwnORNKNaJSeE/xbSDi74nhL7GbpJzVs2UfemsXfN5c+86x7EXV6cnSaf4JWIR+IyucHFRgYGjxqT4XoLgxR8DFTy2N7rRo2xA+/d4AUGQxITthMB7GW6g/IIz1hdnItbc/w/QycBsFoXmM4CpYwngfoPfw9yVXp0AeaHBr4hEPTHaw6nHhc8ML8eQ+Sa2UtAG3DbXvMKtRnj6r1fdIBk=
X-OriginatorOrg: analog.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Sep 2019 12:49:29.9929
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ad4e4a4b-0fb9-4ec1-7fa2-08d740eda421
X-MS-Exchange-CrossTenant-Id: eaa689b4-8f87-40e0-9c6f-7228de4d754a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=eaa689b4-8f87-40e0-9c6f-7228de4d754a;Ip=[137.71.25.55];Helo=[nwd2mta1.analog.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR03MB3651
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-09-24_05:2019-09-23,2019-09-24 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0
 priorityscore=1501 lowpriorityscore=0 malwarescore=0 clxscore=1011
 adultscore=0 spamscore=0 mlxlogscore=999 mlxscore=0 impostorscore=0
 bulkscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1909240127
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Both HWMON_P_MIN_ALARM and HWMON_P_MAX_ALARM were using
BIT(hwmon_power_max_alarm).

Fixes: aa7f29b07c870 ("hwmon: Add support for power min, lcrit, min_alarm and lcrit_alarm")
CC: <stable@vger.kernel.org>
Signed-off-by: Nuno Sá <nuno.sa@analog.com>
---
 include/linux/hwmon.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/hwmon.h b/include/linux/hwmon.h
index 04c36b7a61dd..72579168189d 100644
--- a/include/linux/hwmon.h
+++ b/include/linux/hwmon.h
@@ -235,7 +235,7 @@ enum hwmon_power_attributes {
 #define HWMON_P_LABEL			BIT(hwmon_power_label)
 #define HWMON_P_ALARM			BIT(hwmon_power_alarm)
 #define HWMON_P_CAP_ALARM		BIT(hwmon_power_cap_alarm)
-#define HWMON_P_MIN_ALARM		BIT(hwmon_power_max_alarm)
+#define HWMON_P_MIN_ALARM		BIT(hwmon_power_min_alarm)
 #define HWMON_P_MAX_ALARM		BIT(hwmon_power_max_alarm)
 #define HWMON_P_LCRIT_ALARM		BIT(hwmon_power_lcrit_alarm)
 #define HWMON_P_CRIT_ALARM		BIT(hwmon_power_crit_alarm)
-- 
2.23.0

