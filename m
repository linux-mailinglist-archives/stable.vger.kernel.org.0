Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6E4A692831
	for <lists+stable@lfdr.de>; Fri, 10 Feb 2023 21:23:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233808AbjBJUXZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Feb 2023 15:23:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233817AbjBJUWz (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Feb 2023 15:22:55 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97E9B5CBFF;
        Fri, 10 Feb 2023 12:22:13 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31AI0Kme023208;
        Fri, 10 Feb 2023 20:20:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=corp-2022-7-12;
 bh=SFiUN/F1UiM6kyIhDHKqjeT2UWigp/CmrwWKEKlO+F8=;
 b=E5L8lrNIwuhqJPj2Qg2NnhcPU3Ed4NongBe+f1RQ9fxv6WCsf+Ymg9F1ox4iF4cDgsS0
 t7QI5NYmqc3rRBefu5IHzUiUcOu00SRHAnEMz/31dO3rETVOGHtGpfncyEff5oNSKr/F
 dMUrtFWyyz8g22sLQ/wxHZEoNBdcd/n7uxaNvc5cOvhN+xIJoaT8IkBmLHWQVruIQ5XH
 8PKnqTJKZlFZLsO2H4eNaO4NQt9y+TkFt6gHXrrB8N2oTjoLkAEZerrQynrQTIHzoamh
 zgIRXCemB7FPj7T7FaON8PoEhaAWcc5j00MlXnY+2WNP405vVlidRyBdTJ6rJNGe+x81 ZQ== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3nhf8ae61y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Feb 2023 20:20:36 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 31AJk2H3002653;
        Fri, 10 Feb 2023 20:20:35 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2103.outbound.protection.outlook.com [104.47.70.103])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3nhdth9qa8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Feb 2023 20:20:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kcwtlA39xZ2bD/n/VDu9FZtOH8gabSg7GMTeqcO6vzEwGNoKiFZX2+i4g4/kTfYULwuEgmw3T6ZqVOSDwfyg1fGeO8ANuV+CqOfs/abCFenu8hTJW6LTV+uMUUG79C7cdkms5RMtK9BPIMtZKPn2xtmLA1SJWvv+4sQCLMM1Z3YrjmjXasLG3HATlH0Q86kFespehrncYxO39+J+bvW7JpnGnirpqfhZCI8+Z4HQTY6gE10Z1vZo+0R6A9g5dVFGLkgCbmDM8GOv5Pg4rj8xq5bVj/zk7WZBsBPKl/QvQYePZSyZl8qH2aOX9hdGtPjuOqbx7837+MtqSkduECEkog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SFiUN/F1UiM6kyIhDHKqjeT2UWigp/CmrwWKEKlO+F8=;
 b=DHyFcWQ8c4CueVujr++o702mgXd5hZm4muZw7ntq2IzrixubqoCCCumJRQUy7iNISIhG8TFYZcvpk1bL69c0dpg7yztGvID6KNR+NRIVZgZJ0jvzmSwWrRtN0vbZ8hqCnLXnnBMpKn3enB6kMK+VEIQmuMrZhSxaAvWTv5EDPUfVF1zClj294cTrpDt6QeUJWiFcw3TFsVWOTYQUmELCnnixkcJYioCZ5cPFb2j6yiTWX8/wGActZre1TGjZPydjfGJSP+f2LNagv0gfVVAlfx4VZn9mEfkCqEbVN9QGBLGnC6I8ZvdbxGaYQtjPxnX3MlzvoZXBTtdR33yB95NPcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SFiUN/F1UiM6kyIhDHKqjeT2UWigp/CmrwWKEKlO+F8=;
 b=bcMFqVsM9FrSidDkZmsoOBA4/5U3B37qtBzowD6B/mOiXfXJ28jyVyVZucz3r6PIm4qVerSazkWCWgKqdy8OGEwCdxEZcylG2f8LtIeACjXh5C66Z1onzk5++mhmlM2D5Jo4q2oUuww/jJrfyJGpiveM2qoL4KvprTABLBuAza8=
Received: from BY5PR10MB3794.namprd10.prod.outlook.com (2603:10b6:a03:1b2::30)
 by CO6PR10MB5652.namprd10.prod.outlook.com (2603:10b6:303:135::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.19; Fri, 10 Feb
 2023 20:20:33 +0000
Received: from BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::f37e:ad45:7d9e:d84d]) by BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::f37e:ad45:7d9e:d84d%6]) with mapi id 15.20.6111.006; Fri, 10 Feb 2023
 20:20:33 +0000
From:   Tom Saeger <tom.saeger@oracle.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
        Rich Felker <dalias@libc.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Dennis Gilmore <dennis@ausil.us>,
        Palmer Dabbelt <palmer@rivosinc.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tom Saeger <tom.saeger@oracle.com>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-riscv@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
        linux-s390@vger.kernel.org, linux-sh@vger.kernel.org,
        "H.J. Lu" <hjl.tools@gmail.com>, Borislav Petkov <bp@suse.de>,
        Kees Cook <keescook@chromium.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Heiko Carstens <hca@linux.ibm.com>,
        Christoph Hellwig <hch@lst.de>,
        Yoshinori Sato <ysato@users.sourceforge.jp>
Subject: [PATCH 5.4 v2 0/6] Fix Build ID on arm64 if CONFIG_MODVERSIONS=y
Date:   Fri, 10 Feb 2023 13:20:21 -0700
Message-Id: <20230210-tsaeger-upstream-linux-stable-5-4-v2-0-a56d1e0f5e98@oracle.com>
X-Mailer: git-send-email 2.39.1
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.12.1
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MN2PR15CA0008.namprd15.prod.outlook.com
 (2603:10b6:208:1b4::21) To BY5PR10MB3794.namprd10.prod.outlook.com
 (2603:10b6:a03:1b2::30)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB3794:EE_|CO6PR10MB5652:EE_
X-MS-Office365-Filtering-Correlation-Id: 5c473f77-e712-41a5-f44d-08db0ba442c7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YOccGvVVNt/87bdxTeL4+VPAYdNh0PA4HWuQcgtsfUlqwHPUncc9/rNm9PeBmDlW+haZJXVBEI2bbpm900cYl/UuYH/7/J+XZxpWJUAEXu2M8BW9aEKnYPyKqBEviRp+zolgVwoMCw7CicFDiSnSPQ+OBKm4XAO9ocCiZcUaLowLKo3rK6Pq/XmSBmYw9HHBTwlyB8X0ntW4DsULVvHYBc0Sz76j8LDi/YIgGyP6tVozWBmrpuDtxP+2bm9qo6bVCISkcfZao6U22ioVI3RBUm6i6ZZaPX4s5PL+DCR4ua8zwd+vXLCRIiinoM9J97eFE7zIpKXod64qMGLtaLE0/bqCg1cyTz5421cKNQ9PWnSUGJiEn/mOQwX7f++NzsaWjn2P1T74ZOf0C9HJxIbbXQkMSy/YQPut/17V/KcQfjr9mWX4JMVDB3FCUJvqVXnL6WQSJf/nzbWP3eFEiIWXn9bcSgWKBs5k8nLlP8bF8rhREeo+G3Nvn16rRJyYKuvm4NH4MMYA8CiFYvaaZ6Q2paQoOBRNhifVlv5TFVgFqtI7SGrMzo4v64w/OCf8IVNLp8Xl0Sfd6FbSB9ey/B7dIq3fiBr2m91MGgZCnNtXqn65A8XO2/rMeeSbcoIho3fwQ+aiQrmuV7vNGHDnHrrRVQ1cU2lcrt4NF3sT8+TIeV/3hn5s2TX93e1ghd3scqXvNEb249hbcA9JEG+YGDjlvA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB3794.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(136003)(396003)(346002)(366004)(39860400002)(451199018)(2906002)(36756003)(966005)(6666004)(6486002)(478600001)(6512007)(86362001)(2616005)(4326008)(83380400001)(6506007)(6916009)(8676002)(66556008)(66946007)(66476007)(7416002)(44832011)(186003)(5660300002)(316002)(38100700002)(8936002)(41300700001)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TmYwQ09ob1JtSDdLeXgwbG5hSEN2THBKUXpnUWRpZ1Z1OU5oVEdJM0w1T29m?=
 =?utf-8?B?YTl6ZUdyU0tqUUlNTWJOcktWSG9tZEYxWXpvOFNVWHNERlBjdGtCUWVrcnhx?=
 =?utf-8?B?WGJoYUV4c21TZW5OalcwNENHWm05anRIN2hldUp2WFpLMkVLMXJxWnZvRjJX?=
 =?utf-8?B?WmVsZTl2d3BpK0JsVEZiWjNzKzlTeUkwVXhBTEVqRXNNMFhxMUxKQ055MzlI?=
 =?utf-8?B?M1dkY09lTS9Tb0RTa0hOTXV6OUVXR0pyemFVM2syeWFhUzhTQ1hROVByWEJj?=
 =?utf-8?B?RzgrYnZBR0k4NzdLbWZmMXAzYkJRNm0zS2tja0RHNjhhcFJhZ0ZRbk1LMHA4?=
 =?utf-8?B?cWtqeFlRTXVQNnVnd0hxQ21OU0hXK3gyWkxBZUJVNitCREx3alhwYmtYbFBM?=
 =?utf-8?B?T3BqeC9MZGEyWlNkYjUzWFpncjJkT3dSQTdnVnJXdzBNVHZSSVpBaDR2Kzkv?=
 =?utf-8?B?N3Npak9wNVpUTFpGb2duYnBCN1FidW5sVDNPMjd2MkpiY2R2Zlk1MElrWmpy?=
 =?utf-8?B?RFNxdm1IazlBWk9DTUVPd1JtTGd3cWp0TlVZeVVGa1Eyc0lRK2pQakZFRjBk?=
 =?utf-8?B?bk9OOUcyUlBld1ZuTUs0Z3BwTkUyWm9HbGsyaXI1QVVoWVdSSjJDMHZhNjNM?=
 =?utf-8?B?bFh0TUlkdkZvSGtxZ1hqRDJJaFRkbXUyMDV2Ylg3MlNFWndYRWJlTlRSUFpY?=
 =?utf-8?B?ZXI1NUJpcGJSdFNqVThwVGpNMXl0RnBkWUxRbFJHa0svTVZWZFVtZFBVMStx?=
 =?utf-8?B?ekcybnZ0MXFhTUNQenJNRlBNNGVENk83QVp0cTB4VElVSDhpSHVucGRNTG1P?=
 =?utf-8?B?Rkx3b0tINVcrVitYL2ozdVVSWkFQbVJCamo0T21ySWtwNHlxNFYwM1F4VGFt?=
 =?utf-8?B?dlJIT01EeTlsL3hYM2VDaEFCSCtzOEtHbmJuQnMremVqN21JaityL2w2NHdO?=
 =?utf-8?B?WXdOZzB1VVNSTmFTZG5vbzUrU0d3VUhMa2Q2cWNIM1FPazA2MHBzSzBkdUs2?=
 =?utf-8?B?R0h2aDFDS3JMeFNJY3FLNkpFemtQSlUrc3BBRWdmdmZXcTZVWmF0c2pOc0ZE?=
 =?utf-8?B?OTJ5SUFHTC83L2VyTkpBK0M5VmtyK1ExcWthVFhrUHpUanVjMUt4dTFDNjN5?=
 =?utf-8?B?eWNVYm90azdieWhzZkh1REo0cGxrOXp0bkNNV2k3dm9pbFFBVFBWbmdzdndI?=
 =?utf-8?B?cVB5b1ZXS3poSTl2T3VOUHMveGVrS3pVNUlVbVpBYXBUa1RWWlVwMWdMN1Vy?=
 =?utf-8?B?MnlZT2xKaVhVY0c1L2VQZmloRXZiWjZ6SUl0WmNRbWhlVmdBalJ2R2xpZWlL?=
 =?utf-8?B?M1FuUUxLdDNRZjIzNnJwMllSeHRMQTg4MDI4UURXQkRMU2dHSDhoZ01YaDZ6?=
 =?utf-8?B?bGRTb04wTGpUSndmSC9SenlCUTA2U0k2OWpJbElLUWdDV2hVYjBDRjVpaFR4?=
 =?utf-8?B?cXlsNmhrTEJRMFEzSWtPQWtHVHdvUk9vTjlhdGRGZTVNbUsyQTVud1ZRNUFu?=
 =?utf-8?B?M1FvMlBCN3NCZDd3MExzNlAzT3h2c0puZmJWWkF1d0xZb0liU3VqbWZ2VndU?=
 =?utf-8?B?RHZUWU1FSXhsR0pjdExMMUFTdlVFdTJ0S1MvVk92d0RJZUFwcHlza3VxVS9J?=
 =?utf-8?B?U0pHVndIWnNKL3ZXMDhycFdwSWdHZUxGd2Z5L2FaY2JJOTFvejNWOGlGbGs2?=
 =?utf-8?B?bVd4emtHSFp3NEJlU05kejd3SjBRT3BHRzkyeUpaOWhqZEVyTW5kNzFnUE9O?=
 =?utf-8?B?L2oxaS9JY0pXM1Q3WWgyVTlEL29DZGlTcE8ycVdTS25paitMUGxUM1JxV2ov?=
 =?utf-8?B?bURIalcxblo4bmtsNk9QUEhTWFJMYjY1NXJXWjhTOG1mUEk1Q0g0L1g4Zmdo?=
 =?utf-8?B?NzRILy80cDVYZ0xndzZuWWtyRi9SMFBZZ3QwNTJtemxtUTREbWhGVmVLeHJF?=
 =?utf-8?B?R244dXdrbitOeXB2MlJOcUs0d3U5Y2RMUnNwN0NuUTBFUWdoT1NMZnkyMk1a?=
 =?utf-8?B?WS9RbERUaExGNFRFRmdIbTJxdDVmWTBlK0trd01UWHk1VXNQalVyUXVJWk5F?=
 =?utf-8?B?TzJqQmxqem9TV2tpaFpWTG9iOEZmVDVjRUNLRFRpMmFEZUVkYUw4dS9Td0Fi?=
 =?utf-8?B?Vm5DZEQ5OWRPM2p5aDhyTlVNUGxhR3BLcG8rUWVudUROcUgzeHA5czV1bUEr?=
 =?utf-8?Q?YlUU7UkYE0ynkHgg7ENks4A=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?V1I5clN1d3ZoOCtEQlpNa3pYZmg3Tk1OMDhiMDNvK01IUVpKV1lWYVZveU5E?=
 =?utf-8?B?bnpVZE1iVmlrUFQybDU0WXlUMkQyRVBaclhEbXY0NTVmZjlYN0tsa3MzVjdV?=
 =?utf-8?B?eEhtQmRBaGQ1TTFGN3U0OUtQMGp0cTRzZzBHQUVOUVhza0VuNkdPelRoMlFV?=
 =?utf-8?B?YmFjUHhhMVFZdEpDNXIzemNrcnVTZlc4Q21oU0dVVG8xMDBiblBJcWZPblYx?=
 =?utf-8?B?NEgraENmVDV2dmJTbFdJcTc3VE5Rd3dhOElSNFdZY3FLMWFZNWN4T0t3Zjl3?=
 =?utf-8?B?cHF5WXRNQllXNEdSTStpVUEyYXozdDNCVGg2dXlpTHUxT1lCR2JEMVVDVUpB?=
 =?utf-8?B?K2JNWlhDN3pjUnBiTVBNSThYL1VIdVdUWTBvc2laNjcrb05yNjFsVWlkN0Uv?=
 =?utf-8?B?SlpyRzBIOGpqME9VdzJHck9JUlA3Ukgxak9GeitiOUZGRlU2NUp4Y3E3UThQ?=
 =?utf-8?B?NG90ajZTSktjeWpSRWVxWjZOTk1kRjZKQ2k2YUFJZUtBVmJNYkVnUTArWmpP?=
 =?utf-8?B?MkRMWHdXcDZtS2FJSEt2N0Rxb2JWYlZrekxVOVlXK1ZLaENnU3lLRHlTUjRE?=
 =?utf-8?B?eEhxaHdsT3VWSVBnOVk3UmFrRy9CN2dFa0hMRmlsWDlCbkRpV2FsQTBJU2t2?=
 =?utf-8?B?aUJ6QkdWUGZ4QnFuQ2FKdHIyRzl4RVBZM3crSFErN2x2QjRlUWphN1haZ2w0?=
 =?utf-8?B?Q244WFVtUDI0eVJHUzVaRkN2blg1Tnd6YW1ZK1UxQVlGVW1zeVdJTmM0RU5E?=
 =?utf-8?B?NGZpVEZNRS9jdys3QjZkZlduUERFeEZUdjlXaHNJSzAyMEczNHJmTVlyQVNh?=
 =?utf-8?B?VGxXdXoyRG5UVVllR0tMUU1reVpjTTU4UjVaRS9kb2xjOW53dDZ2Z0FJcmYx?=
 =?utf-8?B?bENGNWd1V0pCM0N5KzdPVmZRcGZKSDM1MGlVQytsa0dpR2pGRUxLcjVoTjhy?=
 =?utf-8?B?YnRxYUlBRFVLclJXV004dWRrakhXcDAwbGM2eFl1TE5ZdS92RUVURHBCaVVH?=
 =?utf-8?B?Q1h2VmRaUzZVS0hueDMvUzRLelMyNFJhN2dCaTNWdklud2RGdXd3blN4NWgx?=
 =?utf-8?B?NDRmd3N4bXVQM0JWMXlpQ081d0IxTk4wRWhxWjJYY1czL3hYaER2dHIzN0ht?=
 =?utf-8?B?RzV3Rm5pVU9mS0IxRk5wTmEzVmJtRjRoL0dBY3plTmpBcy9WWkdPZitJbUpt?=
 =?utf-8?B?cEhRQll6bVlOSWdWYXRDaVJENzlKSUlzUllOUWtwSzFIeWRsRXpYRU96UW5k?=
 =?utf-8?B?VDE3WFZ5Z2JLWEpka2Jya1dnaHp1cGpLOG5rWHNKeHhxSE8zNHNpcGNwczlY?=
 =?utf-8?B?cU1jbzZjZVBudjU3WW9mRFJzZzhiOVl3YWNrUGY0S2V2OUtVRU5iYUZrcVhN?=
 =?utf-8?B?U2h3dTAvWGhhMGh5K25OTytJMkgydFp3cHBGcWttc0tiVTdVa3RyYkxlLy8v?=
 =?utf-8?B?c0lKQXpLcDJ5YVQvcVJyb0RPK0YzbVA4NGJVMkRmQmkwelpYQk1taGFrYktL?=
 =?utf-8?B?TWY2Uk9rMEtvemJPLy9HMlNSY25XaFJCMmxxTnJKY2FSWXNOaldaSGVCWmZy?=
 =?utf-8?B?YVVCUHNoMEhOdmU4MWpFeFJDdzNHOHlMVys4ejhkUEMzM1dHVGxmSjFSR3N0?=
 =?utf-8?B?bXg4S2l6OWoxaDAveTcrVndUaWtreU9KZzdoWkNPNzhmTGN6UWJRaG9LUThV?=
 =?utf-8?B?aG1FUmtwek8wTFJ6WU1oRWZpdlZ6aHhPYVFLMy82ZmJmUmdpRFNMUUVFdFRE?=
 =?utf-8?B?M0dITWtOVzRDMklHM3Y2V0VTS3V5Y2ExMWQ0c0pzeVRjOFl1eVpxMDc4SEVy?=
 =?utf-8?B?WHBMTDU0Y05KeW5JcnJnajVFL2s5VXpUM2ozQzBQV0FVUVQvU3B0R0hzckhL?=
 =?utf-8?B?dUd4TC93NnhkdzRGTVprU1hvbmpRR1ZCbVlVRVFoU2lMRTlUNUZsQ2wrMmh1?=
 =?utf-8?Q?JI1C4LUYSGs=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c473f77-e712-41a5-f44d-08db0ba442c7
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB3794.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2023 20:20:32.9124
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CuYrhegRZJ3GE6stH2WTD/408AWJhcUDVA+eeAm2rA5LX61iHMpeRqu2tsp5WidLziy66doHBW8F7x1Qo4eoZw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5652
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-10_15,2023-02-09_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=989 mlxscore=0
 adultscore=0 phishscore=0 suspectscore=0 malwarescore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2302100173
X-Proofpoint-ORIG-GUID: A_10d_DpWOvYIkdBy389oiuUQsTK-K-z
X-Proofpoint-GUID: A_10d_DpWOvYIkdBy389oiuUQsTK-K-z
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Build ID is missing for arm64 with CONFIG_MODVERSIONS=y using ld >= 2.36
on 5.4, 5.10, and 5.15

Backport BuildID fixes.

I've build tested this on {x86_64, arm64, riscv, powerpc, s390, sh}.

  # view Build ID
  $ readelf -n vmlinux | grep "Build ID"

Changes for v2:
- rebase 6/6 c1c551bebf92 ("sh: define RUNTIME_DISCARD_EXIT") from upstream

Previous threads:
[1] https://lore.kernel.org/all/cover.1674588616.git.tom.saeger@oracle.com/
[2] https://lore.kernel.org/all/3df32572ec7016e783d37e185f88495831671f5d.1671143628.git.tom.saeger@oracle.com/
[3] https://lore.kernel.org/all/cover.1670358255.git.tom.saeger@oracle.com/

Signed-off-by: Tom Saeger <tom.saeger@oracle.com>
---
H.J. Lu (1):
      x86, vmlinux.lds: Add RUNTIME_DISCARD_EXIT to generic DISCARDS

Masahiro Yamada (2):
      arch: fix broken BuildID for arm64 and riscv
      s390: define RUNTIME_DISCARD_EXIT to fix link error with GNU ld < 2.36

Michael Ellerman (2):
      powerpc/vmlinux.lds: Define RUNTIME_DISCARD_EXIT
      powerpc/vmlinux.lds: Don't discard .rela* for relocatable builds

Tom Saeger (1):
      sh: define RUNTIME_DISCARD_EXIT

 arch/powerpc/kernel/vmlinux.lds.S |  6 +++++-
 arch/s390/kernel/vmlinux.lds.S    |  2 ++
 arch/sh/kernel/vmlinux.lds.S      |  1 +
 arch/x86/kernel/vmlinux.lds.S     |  1 +
 include/asm-generic/vmlinux.lds.h | 16 ++++++++++++++--
 5 files changed, 23 insertions(+), 3 deletions(-)
---
base-commit: 59342376e8f0c704299dc7a2c14fed07ffb962e2
change-id: 20230210-tsaeger-upstream-linux-stable-5-4-07f93e88c218

Best regards,
-- 
Tom Saeger <tom.saeger@oracle.com>

