Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B53BF5B4767
	for <lists+stable@lfdr.de>; Sat, 10 Sep 2022 17:59:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229572AbiIJP7N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Sep 2022 11:59:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229561AbiIJP7G (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Sep 2022 11:59:06 -0400
Received: from GBR01-CWL-obe.outbound.protection.outlook.com (mail-cwlgbr01hn2246.outbound.protection.outlook.com [52.100.178.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89B063F338
        for <stable@vger.kernel.org>; Sat, 10 Sep 2022 08:59:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kZVdLDjTi4TZ9/kOvcJpqMN2qXbUgOfJrPNhznjs+oIyIlD0IKPyw5L9CxHOH3xjoJK5u21Stl96jxwpeWPdKpmwkJmNMTXYlud1/7Ia+lnVorVqCrzTPUzC4tYPmsiHjjxJOd+JFxw6lmLMxPMjjRGqE1lNYgfj+wt8YNkxMu6w/l7Z0pfwWikYehxXUQaIu8CwhQjdXuz7dSBb4mEb5/od7WRj8K6pKw58madMUilaOhERHO3f9Chr6f1XqxckMfCaxHDpjTMVYScOMTjDtPqBKKkUu0ZzXSL7/+D5LajugupGaIkv8NLFeEZsrx1/pjRFWjsem+wC5oeW0KHpzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TOjos4SxUFZAeQpM337uJx9fctH1FQimDfCd3SHJ6zI=;
 b=RGprKXgVpEYqLo6BNs5Jab0lXcQ4GwstWphbgg+9n5jxRIwE6s9pXe+BarUXRiqZ/HSysViW/a8mdKzbdQhLUksUGYVRvLerqHmRAp+JoeIDnRD4BpEddC5e4h9lnYJo259GlIlCwcW6u2JbEIkF5leNHke4nL9sWpqX9s1IQE+eR7VQdfPXn3DNcJhpY6YEJvwMeH5HWh1HIUym2cUvCcRXOs1kn996KgKWD+7V9Ju/4SYSXcUYwxbAjjfxgpOdMyu+Pe+3tU24HmRBWXjWtcrVriXTxGfHfMdoaumDIxKEfpvh2DocwYkB79h4595LAEQG1kCaDmsB2yosP4w7XA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bywater.xyz; dmarc=pass action=none header.from=bywater.xyz;
 dkim=pass header.d=bywater.xyz; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bywater.xyz;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TOjos4SxUFZAeQpM337uJx9fctH1FQimDfCd3SHJ6zI=;
 b=c1YQLc+KrGRUen6h/w32JJF09oAo/FJ73h4UOUczJx9RtdgLIJZeDsZseY4vICW78EZoVjWo0wTDc0fOb50GWFZkZ3mleToZFqoVDwRYp6IBY5G3waZF7NIgsAQeIMyf6InfoHkU0qOnSrFx/T4BBX2JEHbz3CYlOz0fya6l6rL1qQHUJMFEA6ArdJlCRx/u6axU3x0xUsGXYPgLWhW2+OSR5uVuRK07nKAC+HWOjGjIfOz0fjF0/gVd2AaR1I25KaQEMKijphIZIyT2G+kwEih+3jByTy2DdJzEVbW+XTwk9FNSRFDiTuR7mpaZDW1+Ay7CYS9hpxr+bwptnApJ+g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=bywater.xyz;
Received: from LO4P123MB4995.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:1f2::7)
 by LO4P123MB6466.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:29a::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.12; Sat, 10 Sep
 2022 15:59:03 +0000
Received: from LO4P123MB4995.GBRP123.PROD.OUTLOOK.COM
 ([fe80::e11b:26a4:86c2:f2f5]) by LO4P123MB4995.GBRP123.PROD.OUTLOOK.COM
 ([fe80::e11b:26a4:86c2:f2f5%8]) with mapi id 15.20.5612.022; Sat, 10 Sep 2022
 15:59:03 +0000
From:   joseph@bywater.xyz
To:     joseph@intrigued.uk
Cc:     SeongJae Park <sj@kernel.org>, stable@vger.kernel.org,
        Juergen Gross <jgross@suse.com>,
        =?UTF-8?q?Marek=20Marczykowski-G=C3=B3recki?= 
        <marmarek@invisiblethingslab.com>
Subject: [PATCH 02/50] xen-blkfront: Advertise feature-persistent as user requested
Date:   Sat, 10 Sep 2022 16:58:05 +0100
Message-Id: <20220910155853.78392-2-joseph@bywater.xyz>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220910155853.78392-1-joseph@bywater.xyz>
References: <20220910155853.78392-1-joseph@bywater.xyz>
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=2693; i=joseph@bywater.xyz; h=from:subject; bh=jK0oka/Ek5n07k8UlB+m5oDvUX0nDeixVl6gKpDbwXI=; b=owGbwMvMwMVY4z6xXz5G8T/jabUkhmSZLUzm6y6f/T8lUJXvwB6eRke2a/O8PK3vrPPfFDclLt6v mONmJ6MxCwMjF4OsmCJLkvQsvtfs62oLdq4VgBnEygQyhYGLEy7yZxL7/+zLxyZv/HddxJ7npvIiAW GD5Gv3ZL8ZfI1d4Kz9pDZu+bH890mB1fycz0UsuhtWqS/X2HP5z45Oq21LNJ1dS7OK8tKWWejIe7gv iCjieS5zcqnStj7x85emdURPZFDq3ett+YLh+8vtQsGcF+IebStYoSuR9nWOd8Qk5ZdLRN4+cRHe6P jsQqLsmm/76nSZm05/f6BfmBnakHPbdf/TTSXm0dHMfhpC85jWBC3vqua9Ua2/J5NrzdX9Vx9dud5Q JzqDt2Zfu56f70d/P7MV6zey9mzJPDrpt+SV+WlGaRw1jl3Gt/ZedX/63ty3dIdsl1/PKr73y941te 4S9zO4XOlxSFNq9u4J/Fx7ukQDAQ==
X-Developer-Key: i=joseph@bywater.xyz; a=openpgp; fpr=621B9A0EEB07AE7D70B9AD107C47918F1F5C21FF
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO4P123CA0093.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:191::8) To LO4P123MB4995.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1f2::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LO4P123MB4995:EE_|LO4P123MB6466:EE_
X-MS-Office365-Filtering-Correlation-Id: 095d3641-1570-48f0-25c9-08da93456208
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?NFg3aVMwNzJ4aUdENDRrd1ZZczVidVZJYUw4WDVhZTdVOGdTZ2lrai9zaUla?=
 =?utf-8?B?ZkRwUDVIMmpHNXRaS3gwOERzbkFXZnAzckdyRE1SQVhUVEtqNHVZeGpPaDJ3?=
 =?utf-8?B?SUNwdlozbXM2cEUyd0Y2c1NmNG43TXNwdmphUlVNWUxMMTRibnVpcFNET2d6?=
 =?utf-8?B?Y0VHWGtNc0hjNHhwUUtNVUJjL1A4bnBDNzdwSERITUk0WkFJU0dHdytlS1M1?=
 =?utf-8?B?QjBzMW51WVQwOStuUW1xei9Wcy8zeDc4TEVycks0b1VxTjkyM1FuT01yaDBB?=
 =?utf-8?B?ZEdXek4wd2tNSVdQUzdqUFNkNTJOUEhwM0w4VzRIRy9oMjVTblgvdU51emlv?=
 =?utf-8?B?RnpFR05zY3lEWmk5UEtSQ3Nrb0tDNkVvdllhbUZhMFEzSmNja2lrckd3TXB0?=
 =?utf-8?B?SHBxVktmbVRsZk9BWEkyK3BhMGJuUjRIUGU2ZzFxZWgzZ1hwclpYRXFyOWx1?=
 =?utf-8?B?M1dkcW41RndhbkhDQUtweUNxTXNFQm1ibnV2MVNTNFozTVFoOVVZNitXejNG?=
 =?utf-8?B?anJ4Mk5WNS9CZmVwS290Sy9ObGgxY0NGOFhwY3lBMk9ZVW9WbHdtbU1ONHd3?=
 =?utf-8?B?WmdPZCsyMUZxejJlWmVXbmF0eGlpVXdzcmFFcTFpaDV0WVVWT0o5VG02dk9l?=
 =?utf-8?B?R01WTitXZVc2QmhJbmZiTng3RzN5RnBuQjN2aTFyNEJlOCtJYWZFc0VzNDdi?=
 =?utf-8?B?dmRuTTRiTk1VMXNiQmlHRkZyUzI2TW94K0R2SmJQUzJiVHAwaFJ3K2VNLzZE?=
 =?utf-8?B?dXFlT0h3ck9LU3ZTeEZ1S1JHOGpmd0ZUcUcvUDBQUU0wVmJyd2lUUzR1SnUv?=
 =?utf-8?B?SUZIRlpZZG1la2dHaEhUa0lmaitTMHREQkpQa2FUUXp2eUlqd2dCY2FucEsv?=
 =?utf-8?B?ME9vTDFBOFE4SHYyeDdHSGR2UmI1UEpDaEJRT0NnRFZxVk01WXVGTXJDWTk2?=
 =?utf-8?B?VE1nUTAweXJ3NGttZjFJL2o3YytZODdhYTR1SWhDRnJtZC9FdE1CMGkvMVdF?=
 =?utf-8?B?Tkt5YWw3bDQ5OU83N0FqZlEveExEVm9WTzR4dGttOVZ3a2c3WEZISFdUeWRo?=
 =?utf-8?B?VHptYkZ0c2pQa1dzZWdJV2dkYmhMRjVFSldzVWdkQ2VlSjdDcHljTWdpWlVr?=
 =?utf-8?B?UHU3aEVueExLd0VBNnlnRlJIc1hXTDM2OWZ5MURkK1NlRy82dk9ObkV4b3Jk?=
 =?utf-8?B?cFJkNE5uQllrUmh4cklxLzkvbC9XWlJ0dUliaVJHeEltWkJWd0ROOURkY0Z0?=
 =?utf-8?B?cllKc2NEb1h4TFhvellad3IzWWorYm9Qc2dyMlRNaUlneit2bHowbjZqRWVM?=
 =?utf-8?B?TExQZ2MyQ2pzZUhVVDExZTU3dGV6QUhpWWhXLzJnS0FoOU9rOWgrQTZYcVRF?=
 =?utf-8?B?MGQwQVFpWmJwekFPNDgxWENyR2VXQ0VEMnBYOVVDeDVZalQvZlFWUUlkRVBK?=
 =?utf-8?B?dXlKUUJHVkdITlVzZlFsQm1jb3JVaXVzV0FDelNuTm96TURzUmVGbnFqc005?=
 =?utf-8?B?RnhieTFzME9VaWYwd3pJeFQzVjZYVFh5cDFLTkdCbW55eGFpa01RTEptVlpN?=
 =?utf-8?B?NEhINjFGQ21GSEJJbDNNd0NmMjc5dDRLS2tkMlBLYS9SMWVOVHVLaHl6TFlM?=
 =?utf-8?B?ejRTYUpqWit4MWN3R2xLd295bXR2bHc9PQ==?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:5;SRV:;IPV:NLI;SFV:SPM;H:LO4P123MB4995.GBRP123.PROD.OUTLOOK.COM;PTR:;CAT:OSPM;SFS:(13230016)(136003)(366004)(346002)(396003)(39830400003)(376002)(83380400001)(54906003)(966005)(316002)(6486002)(478600001)(36756003)(2616005)(2906002)(6512007)(9686003)(1076003)(6506007)(186003)(52116002)(86362001)(38100700002)(8676002)(4326008)(5660300002)(66946007)(66556008)(66476007)(8936002)(41300700001)(34206002)(4720100020)(309714004);DIR:OUT;SFP:1501;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZWY4MTNKMVp5bVR6Q3dUSitDaGZMOElNVVlHSEEwWG0vYUF6eEd0d000NTlv?=
 =?utf-8?B?OTl5VXFYbzlTV2lJTGZtM1dnaDBaMGVvZnZYQzFrOWdpcHMzMkdQVGZoQ3BV?=
 =?utf-8?B?ZFU3WmVkSVZqakNxQW9aMElFL1lXaGkzdmVOZlg1ekhISXhDTmt0MFByT1Zy?=
 =?utf-8?B?Nm56QTdOc29LcVA4STh0VGFNa04yQ2RLWEgrR0hUeWNFdWhjOFg5Z214ZlpI?=
 =?utf-8?B?MVZmRUNKVmRaQnZ6aHQvV2tVRXkwNENsV0VTOXZQL1RVVGdNbjFGem5qUy8x?=
 =?utf-8?B?eEUwdGtDSS9RajVCSzZldTNlYUJ3VTJaQmFxTDRsdDdlRVRQUTc4VEVKcUY2?=
 =?utf-8?B?d21mMmcyRW16eG9ZUXFVSGN5NDRpRTF0RDN2Y2RjRHJkRjFuS3Y3MlgxWW15?=
 =?utf-8?B?MUdZQk94VyswRjU3K2o3aklGR21uV01TTjI0c0RYc3dJUTUzdnRFVzlOMHJS?=
 =?utf-8?B?RWNmbmxuOThpMHNJT0VYNmswTEJFRGZXWGFFTjNFMlpTYlNlU2R1SVVtUVhk?=
 =?utf-8?B?Q2Q4N2NwTUUyTm5nU0s0LzNUTEx3WUNDV2QzSTYxZHdoYVZ0c2Y4dHlKaERu?=
 =?utf-8?B?S2M4cjZ5cWVzZHdDZkErN1pMeThMeXJXR2hacGh6bDIrRnV1WjdTc3BnRlht?=
 =?utf-8?B?QjQrNFJEaU9xdjRPOU00dERaamVSR3NmM1QyZ3k1Y0N3eU9udXpWbHZNMzVB?=
 =?utf-8?B?RVl4blhzREVocEZKMTZ3SjBCR3pqR1VGeFdTcTc1L09rTnBUMk9tV21YZjdk?=
 =?utf-8?B?aXF4MEpmSGRWNi9udDlkUTYzNXZzZ3VqSFFNUjQ5U0xBSlhNQUVMTXJvNXc2?=
 =?utf-8?B?d1BEdGJBNTdrRTJDcEc0aGpwSnYyTGtNZ3FHY1d4U3pOTVg0Y3lINUFMU0xk?=
 =?utf-8?B?SCs5QVNZdFdxN0VKNXlRV0Z4TmtSMlQ2dDNiZ2lwbjU2QzJEQ2Njd04wcUwv?=
 =?utf-8?B?NjZjbjhyUU4yQ3FUWGg4VWltSncvRHdmZExCTWhlVmtHN2pBaWR1cXlTaG9w?=
 =?utf-8?B?Um5MT3JMYysxbG1kQWUzQUZpMGZCQTZHdG9rK0Y2L2VLSk9aQmM2am1GYzNU?=
 =?utf-8?B?dzUwNlljRk1HVUErZ3JVcE9rWmc1Z1NHQzNSVUg4NDlSNGRhakhZMnVqVUVB?=
 =?utf-8?B?a210bUw4ZWp1SnpwMHFLbS9YVmdIcUZBazhVSHpydW5TaUpwaTdYUEZSeXVy?=
 =?utf-8?B?TklRNko1OWtnQTNjbUtvYnoydTZod2xLUU9KblVNcC9VQkhkN0FtU0hWa2Nv?=
 =?utf-8?B?bE5jazJvc1JQKzlZSEZWbk9hdEdSUzF4VG9sVERPbDBDQnRGUzBCT3ZEYW82?=
 =?utf-8?B?OTNyYUtWSTh5SGozL0FDYjJUMVVTUk1ZaGUvUVU3Sm9oZ2ltVlpQelFISlJG?=
 =?utf-8?B?NXl5bytJc2MwYlRFSE5WWVkvRDhoRXRWM1h1cEE3cHRQMkNOdmRPVnhrc2tT?=
 =?utf-8?B?T1hLTHdPeFdMQWhqRitjRmJuTk1VWjFhcVROcVpSRXdmMDlnZm0wYU5TVy9m?=
 =?utf-8?B?WnFHTEx0S0xZdEo1M1hUU0RlT1BEd0dXOHczM2ljeWdXRFZqN243RnQ2N2Ry?=
 =?utf-8?B?UFZJNHg3WEdHTXRsVUU0U2N4WVVCelA2V2QzaVlnTHdQdnRwUUNLWGxWV2RX?=
 =?utf-8?B?VWhPWGRQTTZtZVFlQlhYSHlFN3dlL3JKTldRTTJMTjlxTk1LRnNvMmJIOUpV?=
 =?utf-8?B?Z0p5Q29YR2VINkc1NXlpS3FnbHVUbzdIZXNZaEplejFoRHlsUnRoMUdpMkJy?=
 =?utf-8?B?SkZwUWpLdzd1eUdBRUxCNmoyS0lRSGJ4R1Y2TnFNUW16aVZCSjhiaGFhcVl2?=
 =?utf-8?B?SlQ0NGR6RDRBUGkrVmJ1M296UE45VC9lUXVsWGhqc21lTVJSNXBlT2ZJSERl?=
 =?utf-8?B?Mm5wRUJ6TmhCcCtrN1ZTR2FjRVJoQm4xZWRQMXF2RlUzWG1lU1J2ZUlRSGtu?=
 =?utf-8?B?NFVhZHpyK0k0UEFRYVY4ZjlFTVJiMGd2clhrTDdTR1VCdHRDTnJYczEwK05C?=
 =?utf-8?B?MWlDVGpCVTY5aGFrQzRJTVhYKzArbU9qc2RUWlJFcFVSNHZVTy9oVEJ1Yk5Z?=
 =?utf-8?B?YVQ3dEp3ZmNRSGRnbkxIQVlFKy9pek9kdjJOVXI3VmVVSUovNVFlVU0xZFBJ?=
 =?utf-8?B?ODFkRkorSTR1cG5Wb1Y3UzJuNHZUZGp6UFFvSTZOMVBTWXRadTg1amV1U1Vw?=
 =?utf-8?Q?67buXxQu4dVASlMT2l15PFHCDGmGesAK585BuQNbRUox?=
X-OriginatorOrg: bywater.xyz
X-MS-Exchange-CrossTenant-Network-Message-Id: 095d3641-1570-48f0-25c9-08da93456208
X-MS-Exchange-CrossTenant-AuthSource: LO4P123MB4995.GBRP123.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2022 15:59:03.5105
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 42dcc6dd-439a-483c-99c4-86bd4e2f0f10
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FxHX9YUthcCpdPdmU6XaFGGwr0zgcw848mOeyF1aRBVSAQlPpkqPMvxl+KAaZUdn28grsAzzDGNYBhWy7sQldA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LO4P123MB6466
X-Spam-Status: No, score=2.5 required=5.0 tests=AXB_X_FF_SEZ_S,BAYES_00,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        FROM_SUSPICIOUS_NTLD,PDS_OTHER_BAD_TLD,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: **
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: SeongJae Park <sj@kernel.org>

The advertisement of the persistent grants feature (writing
'feature-persistent' to xenbus) should mean not the decision for using
the feature but only the availability of the feature.  However, commit
74a852479c68 ("xen-blkfront: add a parameter for disabling of persistent
grants") made a field of blkfront, which was a place for saving only the
negotiation result, to be used for yet another purpose: caching of the
'feature_persistent' parameter value.  As a result, the advertisement,
which should follow only the parameter value, becomes inconsistent.

This commit fixes the misuse of the semantic by making blkfront saves
the parameter value in a separate place and advertises the support based
on only the saved value.

Fixes: 74a852479c68 ("xen-blkfront: add a parameter for disabling of persistent grants")
Cc: <stable@vger.kernel.org> # 5.10.x
Suggested-by: Juergen Gross <jgross@suse.com>
Signed-off-by: SeongJae Park <sj@kernel.org>
Tested-by: Marek Marczykowski-Górecki <marmarek@invisiblethingslab.com>
Reviewed-by: Juergen Gross <jgross@suse.com>
Link: https://lore.kernel.org/r/20220831165824.94815-3-sj@kernel.org
Signed-off-by: Juergen Gross <jgross@suse.com>
---
 drivers/block/xen-blkfront.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
index 4e763701b372..276b2ee2a155 100644
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -213,6 +213,9 @@ struct blkfront_info
 	unsigned int feature_fua:1;
 	unsigned int feature_discard:1;
 	unsigned int feature_secdiscard:1;
+	/* Connect-time cached feature_persistent parameter */
+	unsigned int feature_persistent_parm:1;
+	/* Persistent grants feature negotiation result */
 	unsigned int feature_persistent:1;
 	unsigned int bounce:1;
 	unsigned int discard_granularity;
@@ -1848,7 +1851,7 @@ static int talk_to_blkback(struct xenbus_device *dev,
 		goto abort_transaction;
 	}
 	err = xenbus_printf(xbt, dev->nodename, "feature-persistent", "%u",
-			info->feature_persistent);
+			info->feature_persistent_parm);
 	if (err)
 		dev_warn(&dev->dev,
 			 "writing persistent grants feature to xenbus");
@@ -2281,7 +2284,8 @@ static void blkfront_gather_backend_features(struct blkfront_info *info)
 	if (xenbus_read_unsigned(info->xbdev->otherend, "feature-discard", 0))
 		blkfront_setup_discard(info);
 
-	if (feature_persistent)
+	info->feature_persistent_parm = feature_persistent;
+	if (info->feature_persistent_parm)
 		info->feature_persistent =
 			!!xenbus_read_unsigned(info->xbdev->otherend,
 					       "feature-persistent", 0);
-- 
2.34.1

