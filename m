Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B43A69282C
	for <lists+stable@lfdr.de>; Fri, 10 Feb 2023 21:23:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233891AbjBJUXJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Feb 2023 15:23:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233755AbjBJUWr (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Feb 2023 15:22:47 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7416783CDA;
        Fri, 10 Feb 2023 12:22:00 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31AHwhii005533;
        Fri, 10 Feb 2023 20:20:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=r7KjTkFRoyk1VYqkeou6pOGL5sJNyxPRtaHo/h9tUs4=;
 b=td2IIriQsY4Yhbz5BRc/YhawONYFAifA/mc8pYlYglNvwK20uZ6k4JSVegu1seacsyBp
 oJH3V/SjWfxAt0DqkL+f2KtHHRPUg7DzDulE3zoWBrUtTlJT/P0hvKSs6HDHTEMfuAK/
 qPQXns6EHhdfq3P+wpY4puW9pFrQGxEWEQhV4BTwr7iuyvooWUYSTwVl9L+GIFXW0zyj
 Mr3ZdwHZCq+fb+Pnb8pibSbXRvIIgIloHfyW7dg8cLDPm6Bik6lWQxdt/HslM1cqchdo
 vZ5DR28TUjZtca4F7EyHUpIgg5kWWtgmYhhS9ky6+2/1g7W1CzDkYnI0FXGqTiV1/h29 rw== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3nhe53p6f1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Feb 2023 20:20:39 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 31AIvq7E036260;
        Fri, 10 Feb 2023 20:20:39 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2044.outbound.protection.outlook.com [104.47.74.44])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3nhdth2d4c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Feb 2023 20:20:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CmaaECtac0rTQ3EqyeNDJYAoL1MC1wZPXcML4ONGBK80MVY840x0xijOtWwgsXvvd0/azIwVqCzYN/0tJB7G2R42Y795gCimfweL+nvebdd9FYfRgvgkml94fbR4QNElEKeyaO8yuNN50tnkPW2N5MtoxEsnRPCD0iOMlNQnMKi2qBYOiHWhv1St28d7MVtdPgj0dWIf8J1bRS0bJThBW/ex9cDSjuLD5EolLz4HLIY5gJLdEQPMQRqYFVm5/zLCIdtAFtPdlMrB6G+5UlDZM9ghi4NWEY5hOmNos/KjkWfWQ+xsSEVmjuRmYXHDjYf24aGzotxZI3YdKi6pzGpyrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r7KjTkFRoyk1VYqkeou6pOGL5sJNyxPRtaHo/h9tUs4=;
 b=iCuK3Z8jjPn7fYdGVvPARXTnJ54OkTvZseo7a1Re812FOXltJWYtCHp5aVhUts3meRg+ZLcA076aLxzahdD5EViVI78TdctgDpX/Z82nf7TsNR3BpQEdWZnLgVK5mtg5ZqtQkQ4KTFldY6t/n1PdREIbgURT4RVWExkgLvjBRrB8gRRDVdr+M2yJ9VrRZQ67QwUJ0dHNd90SoA1ZW9lj3KRlFxl+8tIAgLkS5GKvOVkmESJ1fZVH1doRHxCS+owMoGUZzY5mtg/lBZWPlyaOfBlk9f6sA7J6JJ2k084BDGsUpIecM/jpLxHwhV76058iqSmbt7xcaRn2zG8odX2xPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r7KjTkFRoyk1VYqkeou6pOGL5sJNyxPRtaHo/h9tUs4=;
 b=ziOesL+sZc3dpUgkrQlS7GShnvTgrDcDPWK0nYbxmL0+UOXOkFj40EilnY46KKYwDgUOa8H1jU6/IzZDR5/2YP7g5RM5nUxNgnjxYfYqnqbgR+KOHkN5IDohl10UqgQcV+J5inQ86x0PGhuW1x3YDR88YPRPELhYNxCFjCLyzqk=
Received: from BY5PR10MB3794.namprd10.prod.outlook.com (2603:10b6:a03:1b2::30)
 by CO6PR10MB5652.namprd10.prod.outlook.com (2603:10b6:303:135::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.19; Fri, 10 Feb
 2023 20:20:36 +0000
Received: from BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::f37e:ad45:7d9e:d84d]) by BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::f37e:ad45:7d9e:d84d%6]) with mapi id 15.20.6111.006; Fri, 10 Feb 2023
 20:20:36 +0000
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
        Kees Cook <keescook@chromium.org>
Subject: [PATCH 5.4 v2 1/6] x86, vmlinux.lds: Add RUNTIME_DISCARD_EXIT to generic DISCARDS
Date:   Fri, 10 Feb 2023 13:20:22 -0700
Message-Id: <20230210-tsaeger-upstream-linux-stable-5-4-v2-1-a56d1e0f5e98@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230210-tsaeger-upstream-linux-stable-5-4-v2-0-a56d1e0f5e98@oracle.com>
References: <20230210-tsaeger-upstream-linux-stable-5-4-v2-0-a56d1e0f5e98@oracle.com>
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.12.1
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MN2PR10CA0026.namprd10.prod.outlook.com
 (2603:10b6:208:120::39) To BY5PR10MB3794.namprd10.prod.outlook.com
 (2603:10b6:a03:1b2::30)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB3794:EE_|CO6PR10MB5652:EE_
X-MS-Office365-Filtering-Correlation-Id: 5cbc6105-8df5-41a8-f748-08db0ba444fc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Nm4e8+jCFEttqehWGgvpMzf9DLKgaqtst2yRQiIN++Tq978u4H2E19Y6xZjmQhsnnVCM61yqHTf7XOEuPdOiK+BvN0RbtTElLBTbo10Qv5rJRubOx6sj98irJ3xMg5CeveXgN+SwG5dbmwbRCSVAYbVQ4oPCZGh8i1hb6CpquqknPE/CwVNCOTu+/dLP25T6tkz/x/t1zOG71pegH1EntWVwFJG97eB72JqKETk5IjrwiHQqOt5mJZLczlI0Ja6fiRVqsBYCYU7XtvphtXehZMBlRCBDGj9eWJn2tgEBcwYEVxiK5AvORn0IrDcReP83TC6QUduFK24PYAUkGvaphWGyG+iRsV+wdPGP5Agr6dxdN52l7uE1y0m0ItaisUu2YEH5hbF91/gjQHHU2LavaxOclw5nr1tYW+AUo3hymIew3U7+8ySFW7C9qTckPphT7IbD0PVEo3ldBvOKtMYrHPkqEt+NNsXFXQ8vPJmjv7BNrV9lr2wOZqszgEyR8vyVZU5MOy60bMb5pGuYUMGLyFf3BbGOEk7N8s/JtUaujbTN05JO75geri9c/b+38jx0jwlmtTSGHDak/sDbgTKT7uEdJz3aGybSCBrPC0+zOysmo+3i3stZBRPDzxnDr3A1kkuYTZN/gIMe7wnH1AxrzcHFor8JLIgU2xLtYga4ClpeqZUnIT4cH6qWor6XeZB3oKJaJc4b1dyA2N1UJrL1kRWgkv3t6ng/v1iKYCnffSA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB3794.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(136003)(396003)(346002)(366004)(39860400002)(451199018)(2906002)(36756003)(966005)(6666004)(6486002)(478600001)(6512007)(86362001)(2616005)(4326008)(83380400001)(6506007)(6916009)(8676002)(66556008)(66946007)(66476007)(7416002)(44832011)(186003)(5660300002)(316002)(38100700002)(8936002)(41300700001)(54906003)(41533002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?N0ppU05ZT0pBeXY4OFJ2UVdBZ1owWTViOFAzZ0ZELy9DN2crLzEvVHBjdTNa?=
 =?utf-8?B?ZVhiSkRhZmVnNUJDWkQvWGxHNmp2TjR2OGk1VmI4WkNJeGN0ei9iSHdNN1I2?=
 =?utf-8?B?SURDWG43UlIxb1o0QUIwcG5sSzdUWDdCZWtwNEx0WEJYbDg2UEptTUxXMytQ?=
 =?utf-8?B?S1MvbjdxUUErQW1IbkpvWnB3czJWU3ZCd3ZBdEFJa21COWZIS3BaR0xuUkw2?=
 =?utf-8?B?RzU3VzVBcjRwRzFtV3JMTG9XSXVsb3o1UHM4cFNubVZQQU5mcFBMbm56YXIx?=
 =?utf-8?B?dVpkQmp6TWpZc3JLMkN2Y1lQNWY3ZnBqbkZ5eTJpVG5WWXJkSkI5cGdzZ2E3?=
 =?utf-8?B?aHJUZktJb2ovdDFWeHJCS0krYm10T3lUUWVmcWJCb1VRQlFGNytMb2J1a0xx?=
 =?utf-8?B?ZGlkcy81ck15bzgrMmRVbTB3TmdPUFNraG9JbDhaeGI0UVlvQng0Zy9tYXZ6?=
 =?utf-8?B?R3ZHS2kydmVBUldnSEVud1RaN2hvVmhqU2NTMGgyMVIza0M4ejcvalhpTUJK?=
 =?utf-8?B?aytuMUZ1NStlenVnR2lmT3grNzhNTlhyL2dQYmJjY3BRMVA4RSsrbHl1V2VI?=
 =?utf-8?B?Tm1tWUNaZkp6TXhWTVNmUWFmd1NSVkJoWXdhYkl5SmxWNXFYTVAwaDEvaDg2?=
 =?utf-8?B?L0RzM1g2WUhJV0JmN1JGRVZPd08raFJxL1lyR3JZR1FGRkNFclhxOGV6Zllk?=
 =?utf-8?B?clpjRkZLWkpBdFRBRi83UW9xQXczVUE1RXJPbFIwemZleExHbkZLa3BpNmJ0?=
 =?utf-8?B?K0F4MVg1Q1V4R3VFK2FjS3VUOGhZYllTdXNPV1pyK1AwTWtQQ3h0VnhhMG1o?=
 =?utf-8?B?ZGpUUkthTjhYOEkrMVQ3bExTdzhjemsxdnVBcUd3WE9IbzEyOEY4cm0wckRU?=
 =?utf-8?B?ZXBqK21HbjU2bDRYaG9sUG5CZ3c5ZFp1TFhOaGtUblRvYzZ2QjZ0KytacFFU?=
 =?utf-8?B?TWJ0amdqWG5qaXkzR3RBcm1XMXNCTHd5cEI5S3VPNnlzRUFMbzYwdnJzWHpY?=
 =?utf-8?B?blRsZVhEY1JYSG0xRlhMd0VoOFc0TmZXS2EwYXY3bmpDbUZCRmRIY1BaN2FH?=
 =?utf-8?B?Zjh6b2Rhc3VSM1Fqazh3NjlxUWJOVXgwd0dKT1BNcmVOTUVqenU1VnVhdlpu?=
 =?utf-8?B?RmhRalNhMkZIaGRCcHVDcllrNHd5a0RydGhEa0lmUUdtQVFZTnhrNXJzU2FZ?=
 =?utf-8?B?NWVLQ3NwOFp1K2xNSVMxMmQ1dHQwSkhJNEd2anRBNXlyTW1od2NNcWMrTi91?=
 =?utf-8?B?VFRuWlhMVU9UaElMNHJEcndoWjlhUDdDZFZObFlsUHBYL3NXZkFFUlg4VEFY?=
 =?utf-8?B?Mld6cW80SmJjSnZ6QVp0b2EvWTZFNGVGZW1sY2NaV1YveXh5TmRmbjVLWTdL?=
 =?utf-8?B?ek5WQmxFdjd5cDhGdDhQQXNFeGpJdUxoUEt5WGRGUjhPcnpPRUFIVjBweGdt?=
 =?utf-8?B?RlQ0Q3JGdVpXZ1dXRHQ1YTlMVGJBZjZBRHpoczNjdmxxYm02SXpoK3Ftb3pS?=
 =?utf-8?B?QlVGNjdtRmIyMlRob05MUHhWa0NvWVBVQjVZZkhSQkRNcWYyaUd3dWtJVmxM?=
 =?utf-8?B?MDY0ZnExT1I2Y3FxK3dwdVpCa0l6MmRlUkRoNUo3WjYzalNvZzZVUHcwZEpD?=
 =?utf-8?B?OEczNXYrRHFnTkZEZmxOL0FNWnBEMHE5dy9mRHhuUTZ5Sjdpd3pVbXlLM2Nh?=
 =?utf-8?B?NXlhUktaQUlSY2FYc1M0TzNkaCtJbVNTS1NUVlBRcVA0a29scHcvUFVMVENE?=
 =?utf-8?B?a3I0TGphemxpbllOZEcvLzBBS1U1OU44WEMvRmUvY2ZteU9zUisrZTJtWmcy?=
 =?utf-8?B?UXFodzBhTE9xU1o4TjdnZ3NoeW5nRjJuRklGWU5UMVp3cW10VEdIb2RvWDd4?=
 =?utf-8?B?elVTV1ZRYlN3V0MvT3pybnVjNldsUUhJQXlTOE9sUVFuNTZUbjRJVnNpRlBD?=
 =?utf-8?B?OXF0MWtlWjY5U0llaE5XTXl1alpYVU1ocGhBVXgyNG85RncrbDFMWTE3a3FE?=
 =?utf-8?B?OUxQYUZlNis1NnBEQ2xTWTNBWVdFTU9wSExJUEx2ODNDNVJDL2RCT3NDM21I?=
 =?utf-8?B?NGRmU0pURkdTcUN5MUd5VXR3bGVULzZaRDFpdnpDNzBLMmdZY2JncmlmcUpv?=
 =?utf-8?B?WWV2SzgzbFNNK0g0Ny81aldJbDFkMXF4N2Z0U1FhWEE5cVlHalJqbmRuc0xU?=
 =?utf-8?Q?cF9/2j73Tq1WDbTbfmI5K0A=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?ZWhPTlYrNUFKd3I0MmpDc1NDeVdZY21ibmxSOENvUFZrL3d0K05kTzA1Qjlt?=
 =?utf-8?B?bXhiMmRqYzErcHd4YXBsbjlMVjEzR1A0bDdKcmRuL2RJNG80ZXp3N1EvdkJk?=
 =?utf-8?B?a2NMVE8zNTJhMktZa1l6YlhyUG5PQkdRaFVjczgyZkNSWmlieFVuOXEvWlh3?=
 =?utf-8?B?d1p0Y1JtOWJYRTVVenlXQnFBMlZPL0JLNlkrRmN3WVo2TG1CdXdxRHVxZkM4?=
 =?utf-8?B?WXMrZU45UjRXcmFwOUltRXJrcGZwdW5XeU8ybmV3UlZGMGo5SmJoRDQ1MklW?=
 =?utf-8?B?aDU0NUVLckxUdmtmdDlRaHhYOGVqS0tHYm50STdWUGg5cEVBWVhnRkpXeVl6?=
 =?utf-8?B?QUZCR2oyWVplMml4dm1rWnZPUjd1NHBuazR4clRxM1hubUVIWHp3WUFWL2R5?=
 =?utf-8?B?akFMaTl4d3RyeThsYzRTOTZTaVYxNE5ic0NJSmRUWkk4MExFRytlU05PZWlk?=
 =?utf-8?B?cGtaZ1dpeE1QUTF0NElkU0t1UU5pLzRMSFBkSThKdFJIZkZBdk9wait1eTlv?=
 =?utf-8?B?dk9TcmlsU24valV2OTNyN2ZaUlkxZ2tMdUYzTmNpV3JPbEdHRXlnQzFQOElF?=
 =?utf-8?B?dkE3eGphdjU0aUxFZ1BTNS9MT05QL3pkZHNxYkhsbU1UTWlmb3RjUHNZNUlu?=
 =?utf-8?B?aU9Eb3VzbmdWaVIvem5uOURNYmtmK3A2KzRZbGxnYUZEVkVqNWdvMlp5UXVh?=
 =?utf-8?B?QzRqM2t6MHkrUGVqcmJuTGhlcG1iT3JUVkNPWEVhc0Z2Yzl3M1VITUYzaC94?=
 =?utf-8?B?dFdpTStpYTBGQUs3WXhkbjA4Y3Bkb1RrTDdKRkFNeDdqczRVTnFoSUJ2VmhF?=
 =?utf-8?B?bW0zTlFJc0NpVW9OMkMyMG5CUWMyYkhVeHNsaFNtVklCYXlib29sRThQbHMw?=
 =?utf-8?B?dTNtYW5KWUdMQVE1ZlM3N2xncE91RDRzVlhwdkFHdG9SZVJ1QVlGREg3SUts?=
 =?utf-8?B?QXJjaktpZkk1QU9zSlBEU3h3eEdrUXlKVStRMFRGaUk3OFdmd0VjNDdKSUg2?=
 =?utf-8?B?MGxJOWttNWtjZWliVFJIMjc4UTB0OEJQOGJTVW9LdkpKc0VMTkZqWEx4dmZX?=
 =?utf-8?B?cDRuS0FRTXh5dnZNMHJCc0p6QWFCeXIrR3BTMDlBaGtENUJpaEpwOXVPNUtN?=
 =?utf-8?B?L2tLb0dUanlVZlFwZUpJRUI3OXpMNWt3TVFWU3dTY3p0WVRjYnRLUW5XUXJy?=
 =?utf-8?B?aGJvdHVncWpnWXFEeUg4RzQ3bTBsY2IzK0h1M04wQjNYM2I2NXJJZjNDZVIy?=
 =?utf-8?B?MHNQZ1A5ckxJY2VKbk9uZ2JoVHVlVHYyV2t6QVVlWjRwY3VNMEEzZnAwZHNj?=
 =?utf-8?B?cE45QVBmTENJVG14NHhyOUp3cjlqMW9JcXQwUTU0ckJqUTRlS3VWbjRibWhT?=
 =?utf-8?B?c2NnbkpSQnIyRFJjMW12MzVGY05BeHJITXBjZHdIaGJmK2RvRXUxMVBjZmh2?=
 =?utf-8?B?cFJLZmpEV0ROdU9DNFpIOEMxbUg3NHgzMGZVemJaSE83alJTeGJYQVBxUkN0?=
 =?utf-8?B?S3BlWGhyTUpWejNBWGZ1VmFGSGRmeXovMzVRKzFyWUpnMDhrdGZvRGNES2t2?=
 =?utf-8?B?YS9FM2wwTTcrV3lqdlNEM3hmbVV4T3d1dEIzUFVxRDRBUlN0T2h2cy9sdGNG?=
 =?utf-8?B?amFMNmpIN1hUcGNMWEliZW9SMEpRaXlJYVUvSS9MSWJzaXlpbGx2NkxmbmJs?=
 =?utf-8?B?SFVFYkZnVS8vUG1oeFhKRndqaFhOSXZrQm5NNlA1Q290dEd2WHdQRE53PT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5cbc6105-8df5-41a8-f748-08db0ba444fc
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB3794.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2023 20:20:36.5684
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7F8JeDv8woMptHQunOU/qj23XY19YKk5CXiygNAD00rkUARpvapXqbAWjEIW4PCxZ9P0iJodL36lyjYKPotWFg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5652
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-10_15,2023-02-09_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 adultscore=0
 malwarescore=0 mlxscore=0 phishscore=0 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2302100173
X-Proofpoint-ORIG-GUID: OmZkZ9rXb3vIbezrscjuRnPcng-x3xVA
X-Proofpoint-GUID: OmZkZ9rXb3vIbezrscjuRnPcng-x3xVA
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "H.J. Lu" <hjl.tools@gmail.com>

commit 84d5f77fc2ee4e010c2c037750e32f06e55224b0 upstream.

In the x86 kernel, .exit.text and .exit.data sections are discarded at
runtime, not by the linker. Add RUNTIME_DISCARD_EXIT to generic DISCARDS
and define it in the x86 kernel linker script to keep them.

The sections are added before the DISCARD directive so document here
only the situation explicitly as this change doesn't have any effect on
the generated kernel. Also, other architectures like ARM64 will use it
too so generalize the approach with the RUNTIME_DISCARD_EXIT define.

 [ bp: Massage and extend commit message. ]

Signed-off-by: H.J. Lu <hjl.tools@gmail.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Kees Cook <keescook@chromium.org>
Link: https://lkml.kernel.org/r/20200326193021.255002-1-hjl.tools@gmail.com
Signed-off-by: Tom Saeger <tom.saeger@oracle.com>
---
 arch/x86/kernel/vmlinux.lds.S     |  1 +
 include/asm-generic/vmlinux.lds.h | 11 +++++++++--
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/vmlinux.lds.S b/arch/x86/kernel/vmlinux.lds.S
index 1afe211d7a7c..0ae3cd9a25ea 100644
--- a/arch/x86/kernel/vmlinux.lds.S
+++ b/arch/x86/kernel/vmlinux.lds.S
@@ -21,6 +21,7 @@
 #define LOAD_OFFSET __START_KERNEL_map
 #endif
 
+#define RUNTIME_DISCARD_EXIT
 #include <asm-generic/vmlinux.lds.h>
 #include <asm/asm-offsets.h>
 #include <asm/thread_info.h>
diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index c3bcac22c389..2d45d98773e2 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -900,10 +900,17 @@
  * section definitions so that such archs put those in earlier section
  * definitions.
  */
+#ifdef RUNTIME_DISCARD_EXIT
+#define EXIT_DISCARDS
+#else
+#define EXIT_DISCARDS							\
+	EXIT_TEXT							\
+	EXIT_DATA
+#endif
+
 #define DISCARDS							\
 	/DISCARD/ : {							\
-	EXIT_TEXT							\
-	EXIT_DATA							\
+	EXIT_DISCARDS							\
 	EXIT_CALL							\
 	*(.discard)							\
 	*(.discard.*)							\

-- 
2.39.1

