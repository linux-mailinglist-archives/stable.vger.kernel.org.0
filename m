Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 059376798A8
	for <lists+stable@lfdr.de>; Tue, 24 Jan 2023 13:55:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229522AbjAXMz4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Jan 2023 07:55:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233617AbjAXMzx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Jan 2023 07:55:53 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB2D426B1;
        Tue, 24 Jan 2023 04:55:35 -0800 (PST)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30OBi5fN014732;
        Tue, 24 Jan 2023 12:54:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type :
 content-transfer-encoding : in-reply-to : mime-version; s=corp-2022-7-12;
 bh=PJwF37OwXvwThTO/E9IbLe/f43b13UFQbvvFpDzoVYs=;
 b=BaNJlAOpDY3dN7jtiZa3J/oR7B5bljIipBBcefAaJ3Lv+Z0M4fzbbp5xoAKc8AdzNLrO
 jUXX3ei67IEjNvPnIijajkDF1DSS9BwsMiRMZd+JAtDAOTNhGjTeUX8lPcdfnHipqFsT
 7aVaaJ+ZgQkFuwUfupIzE7+NcHZhxXQLhaHIhBd7G4pXJeFv/sk2jn19ohd3DZq907eq
 /0NR81Wkpn8BLjxGQWMIKz5DiXfNZQpsAu7eMfol5pZqm0ciQYjDKW8uMjjaT+85jO7B
 7fOJDN516hFZYTgIvPDmXOxAPLsnBtsIO+4YO+vICMI+kRyV4Q1HIP/LDD0r6VBFySgV jw== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3n883c58h4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Jan 2023 12:54:58 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30OBmn5l025353;
        Tue, 24 Jan 2023 12:54:57 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2102.outbound.protection.outlook.com [104.47.70.102])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3n86g4ck93-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Jan 2023 12:54:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QJwKm3y0qTGzetxgOiCU4QRiEEHZW4laId6ExfVdXMjc+HHXVwh95POF+p6vcHh6U7PKhi4YRs1R3w4BbNdZngiwQkSo+ik5CDb38O8D2qjm6Z8+qMOZ9k7/7ytruJKliOswaGfjssGELWRSgac26laayraF+S8aUwxayaMcUAOrZY5hO8wWpEVzbWN6oHJEliP0Cj8AomN4PpD6OtULwlEcqTEN+vqYkiPS0JYcxn0jFWVRjWQfkIXge7402IBtS94hs+K4lBxhYJI0QRj4AsrogSNvdQbJnSfIlsXUXVXcCc/exururfWQiyUBGOyVOWKUhj79smIqUKl3ixEc/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PJwF37OwXvwThTO/E9IbLe/f43b13UFQbvvFpDzoVYs=;
 b=QBLb/5Q5UA0KNi8x7ftsElY2h581VyCYCMIx/e/JkYbhOl2Ax1b408hH31uyRCva7QH1xRjyNR5JLNKeGNNJH/HwAig9jnjHxDcNfiuQPOr9M5ixH1Im/V55vdVWTIisOJm6iSPiZOrtLe2BNdLMKV3It4j0WBij3OQUffLXaH4SAgnzYguJMto2KkER/Gah5yFm0IAIq1RUVzQzSyuI1UpKwym70LY76pDJv2YlPsf2Ig8rf3skU82sb1bXB90BHdQuDH2YzeLcemmRb/ezhJQ6UaB8IAXbvKIAafN2ALNMAmpuSEkXuufyVmbylq8q+XJxjLNCx9D22eHVebf0yw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PJwF37OwXvwThTO/E9IbLe/f43b13UFQbvvFpDzoVYs=;
 b=Q38BLJmrtfP4UySw5eTMf0WhzAA8mvqUFcEq2GkB0UVE6PWSxqekXzJ+80E9HLp9+fQYTKlKQVLeBeFyvVNZKKLpb9UNT+nyfiZOwMzc0bAFgolWuztRYiB0Xu2FpsZCPf3dJXz6d7XYXsqwtWmCryS4S2STYBzIsladL/GPvyQ=
Received: from BY5PR10MB3794.namprd10.prod.outlook.com (2603:10b6:a03:1b2::30)
 by CY5PR10MB6093.namprd10.prod.outlook.com (2603:10b6:930:3a::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.24; Tue, 24 Jan
 2023 12:54:54 +0000
Received: from BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::f37e:ad45:7d9e:d84d]) by BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::f37e:ad45:7d9e:d84d%6]) with mapi id 15.20.6043.014; Tue, 24 Jan 2023
 12:54:54 +0000
Date:   Tue, 24 Jan 2023 06:54:45 -0600
From:   Tom Saeger <tom.saeger@oracle.com>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     Rich Felker <dalias@libc.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
        Masahiro Yamada <masahiroy@kernel.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Dennis Gilmore <dennis@ausil.us>,
        Palmer Dabbelt <palmer@rivosinc.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-sh@vger.kernel.org
Subject: Re: [PATCH 6.1 000/193] 6.1.8-rc1 review
Message-ID: <20230124125445.gqko2lyvp3vmecto@oracle.com>
References: <20230122150246.321043584@linuxfoundation.org>
 <CA+G9fYsS1GLzMoeh-jz8eOMbomJ=XBg_3FjQ+4w_=Dw1Mwr3rQ@mail.gmail.com>
 <20230123191128.ewfyc5cdbbdx5gtl@oracle.com>
 <20230123194218.47ssfzhrpnv3xfez@oracle.com>
 <CA+G9fYvLh=epzy_KEZObfFn1kVCugKvuVWF08X9eEiPe4ehe3g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+G9fYvLh=epzy_KEZObfFn1kVCugKvuVWF08X9eEiPe4ehe3g@mail.gmail.com>
X-ClientProxiedBy: SA9PR13CA0114.namprd13.prod.outlook.com
 (2603:10b6:806:24::29) To BY5PR10MB3794.namprd10.prod.outlook.com
 (2603:10b6:a03:1b2::30)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB3794:EE_|CY5PR10MB6093:EE_
X-MS-Office365-Filtering-Correlation-Id: 7e075d22-a169-45ec-2870-08dafe0a3009
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6qk7RD2ONMchaH2g+dBlthdU8Uh3hWR1Sj6WFxCkAgGfB55vhyziK5uR31IZ6xeo9BH59pb7ThtceKMapvE0BuwnvBhn1oTj1SwTTPPh0aSt3jpJJlGc8PF1WRHlcT128Ytlvzs5WMA/NIfesFV+nG18V+kwH1Ho7mEAbPPsu0hjIm83CNlOvteYNCzfYhcS6t8cUEvtSoMO9z/VmFZ1uwvfqsN004ftEvpoVISGmxuJ7/7xT+Au6Rm9Q9Ffjbb5V3UdS1jXdaJasxmJkLWrFjTnwbpChG1dv8KPWeHpuJ1w98QIH+/NRh8fPbrlUcYBcstDyamPVSv+YKTP5xrKmW7nwSxayu7oRHAtVBqAJYWOgAVOYyt5XtZr1uL3KIzxw6ncl0AaHkptpKd0s9mpgXwRVL+Wk6j9l6mzBA3TXq/KIYlbJ9lTUNNVDa0VPi5JNQE3IV0mAvVFkstWFj3j/LHWezpIM/BLUn1lm1XmVt8lncw+p3l3J6uRC4ZGo98grPOdDeT9oVZ/Y80UxT+wnv+SEGtPEF+AdAa1Vk5sRdp0KLGJCjNP8UJcV1On69l9lApJ2Zx1Ow0TTyHRpIXdW4Z4K4k25FUsOp5dbzneBdNCTJ4XkWIO1xFTM3SUR14mQasCF9WwWVmK2TcpypAvmBzK2bIV2WmlE3W7cqDB5VUFjp79H7EgRBuKqrDlT+ZeJHUJp4LSsK/6x19ELgMjpA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB3794.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(366004)(39860400002)(136003)(346002)(376002)(451199015)(66556008)(8936002)(36756003)(4326008)(8676002)(41300700001)(66476007)(1076003)(6486002)(44832011)(478600001)(966005)(6916009)(66946007)(5660300002)(186003)(54906003)(6666004)(6512007)(26005)(2616005)(316002)(6506007)(83380400001)(86362001)(7416002)(38100700002)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Qm9yU1FnTWpheWM1VVRWYThja2xtRGZjUkpwa0F6eGNzVnNaL3crcW51ZkpD?=
 =?utf-8?B?OGNRNFBZRXVOaWgzcnNEdUc1UjNrL3FPSjgxbUFhUys5cjhQRFREUTd4RS9M?=
 =?utf-8?B?WGllcnRMaGFaTWliK1paaGJCVnNxKy9wY0FJdVpFSGZORHNBcnM0bkkwTkVv?=
 =?utf-8?B?Ly9CODR2QXdYL3lMK3JQMFZzRVEwT2FpelpwVDBDVXdsNkVOdjdEZThnKzFN?=
 =?utf-8?B?aXNGSWR1OXJCYWMvZ3Y0TU90SmNrV3J5cFc2emtHMnBzTVVRa0pFOEQydmdx?=
 =?utf-8?B?RytrRUl2YWlCWGhyTG1TRWVqS0Nic3h5YzBiKzRRLzNVS0lJc0VtNmk3OGJD?=
 =?utf-8?B?aUQxcGtueGxkREI3UFV6Rzk4ZS9zQ0laaWVsc2VSd0FNY1pwbGlUQlpmdmtJ?=
 =?utf-8?B?UVdoS0RoS2p2VmkxWUdGQTFVOTVLQlBrQ3FBQ0IxZzRyKzJOc3k2THRPeDdh?=
 =?utf-8?B?ZUJDaFVIWkhHWmRXS1lZQnd4dThlWHRhdlk0Qm1pVlVIWlg5Q21acEZrRE03?=
 =?utf-8?B?Q05ENm1MMkUxYlp0WC9XR3cyZlNzeEpYQ2F5VFg2Sno4Rnl6ODNJRVBJWFpI?=
 =?utf-8?B?UGFYSWZ5Vk9abnp2akRkM3NUalprckhBOXBNVDdWRENITFhseHN3WUJjS2g5?=
 =?utf-8?B?bkxWYlhBbFZSL1ZGZ2hZbVhwMVhsRVFrWDk3UG54MHl0bkhqdURyNm5lSFho?=
 =?utf-8?B?NjlrK1pSRUhRdlRNenJ1cEZKZmpjWHBlV1lSb3NiT0c4RU13Rm5nRHUxcEcw?=
 =?utf-8?B?K1Q4THJUa2xTdW01Y1RYejNJOTlDUmxGVGdlZWpjd2hQQ3BIdVd6UlBUbTZZ?=
 =?utf-8?B?ZnhRbTRWNkVxQmFHODhrWTJZY085K2htNm9oSzdnWjM3MWFVa3ZMVGRKZHNu?=
 =?utf-8?B?eTJDcUZWcFg4K3ZER0x1UWtFU1ZvL2VFdzF5N2syNVBwVklLY0hVSG44cUxJ?=
 =?utf-8?B?eXQxQnFqa1V5QjZoNzZaOU1QQWQvR3RybE84RHdhZ0sxUmVZMU54T21rTXIr?=
 =?utf-8?B?cENSbEZPTGNXbEUvbnNvSnNrdHRQQ1p1TnVOdSs1bFVZNkMwTlJ4VnloV2lV?=
 =?utf-8?B?Zk9hUHJEMGZGcmN0dXQzS2VjRzgzRUZnb3V3citVQzNLTzRqS0wxYk5uanp2?=
 =?utf-8?B?cHNLNTlMZjlPMUJRcGhRMmo1Um8wT2FWaktlRVdqM0s4WnJkL21HeEN2SFMx?=
 =?utf-8?B?OW8xb2U0Njg2OW96WVNjMk4vbGxFQ0NnRno2bmF5SkNOY2x0M2pUcnErb3k1?=
 =?utf-8?B?NFZBYnRRVkpyYWlxU0xyQWErK094SkE3TnNBNUVrZXZlbnBqcWI1UzRvS1R2?=
 =?utf-8?B?R3hPMzJXNFQ2NU9IbjZ4RDhJWHhsZ2lML3dOc0h0b0s0WmVvNWt0ZE9KM0tJ?=
 =?utf-8?B?dmdnd2xyUEx1TVg4R1B5OGhuZzRpNXRHV1I1WERxR3FtbzhuMVJIWmRFTHRF?=
 =?utf-8?B?RXlYNHE2dXhrQjVxK2lwaUYzSzJkWHZxcEVkUThBdDVtaTh5Q2Nvd082Mndk?=
 =?utf-8?B?bm1uem1DVHRjTWVkeHByaFhMbTVlcSszMmtYRnhxQTB5Q255KzNYZXpHK2hy?=
 =?utf-8?B?T0tDaFNRK1l0ZnlyQkQ5aE1UZTdGZ1E2eHZlUTIyR1FDOXNVLzRsUXlraVB4?=
 =?utf-8?B?NTZTUFI2L2kxTXBkQk9VTEpvU1lYQ1Z3K3FXWGRRM2FxSjB2TGVhRzRBMGx3?=
 =?utf-8?B?TlpaWGlOeHQ4L3pORWZJK0E4MlBmcURncDh3VDh3eUIrejZhbU1LVSt0SHk1?=
 =?utf-8?B?SjRXRU1Bc1AySk1uZC9KVVVtU3IvV1BycVEyeG1hajNZYStrOEVnOWVLa3lC?=
 =?utf-8?B?V1pUNDF4Ky9pL256Q1RaYmFzWWJiV2wwT1hBaFhyN0ROVUlFMEhTbkRWVlA4?=
 =?utf-8?B?cGRLSGI3ZzhiME9DcVRzTThDaUVIcjRaaTRVTHQwWXZxSmphS05KQm5vOGNN?=
 =?utf-8?B?UEdQTll6MnFZZG1YN3FaWUdZRTE5Q3FrNGd5R2o1b0lYUkxWVkJURFJLQ25w?=
 =?utf-8?B?dHNNdDFOejFoQUpudFQ5RGtEeVAvVzFJM2ZZWlBxZk5QNGtvbEo3Z2oxaThs?=
 =?utf-8?B?SkxVV2JRTE84cUVOdk56S2tTYzQxTmdXd3NyUXYxNHh5UzdLN0JzYzNyV01a?=
 =?utf-8?Q?nTR0TpZ4/G/M69nzEEESHJ9te?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?NFVuSDNDeTBVckZvOFF3aFoyNkhRVHNiR3BTWlE0QTBtcGp4WmtiN3ZjbWxU?=
 =?utf-8?B?MDF5YlFaaUIvcS9COTNqNUdKcTBPNVc3OUwyV0dQRHB6TWFYcU5hZk1rdk5n?=
 =?utf-8?B?TDkyRFkyQ1VrSFBLVWQraVBPazgwWXQrRloza2tZNk9yR1RHRUI5V05TTzEz?=
 =?utf-8?B?c1NJR0wzQ2h0dlBZOWt3WWRHM1E0Z1FDZkZINzZXWWsrWEtDdU14VDZVTVo2?=
 =?utf-8?B?WG45bUdneUNGRTcyc25oTHpROTgyTW8zaGNSQ3hDZWJpZ3BaWlR5ejlBMjFV?=
 =?utf-8?B?S1NWYUNJVWxqMjNtblE1Q1FQRlJlSVRTV0VRYloxRW1MTmdSUnYyNFhQMFZx?=
 =?utf-8?B?TDZ5VUpCNHhZaitkNTVTYnRrSFZwY2drNHlwSUJYYjRiRXh6ekhkMVRueDZz?=
 =?utf-8?B?L2Erdll4NjQ5ZjlXZnlvZ1lHYVBFalU0YzZxL3VNSDlCd3dVMWc2Sy8xU1FV?=
 =?utf-8?B?cklraGR2eWdjQkViQzFPNWt6NmpDQkFNWENVS1p3c2hxQ0w3WEU0eU91Z2gx?=
 =?utf-8?B?U3IzdExEUTJWRXFGcEVIQ2l6ZHBJZE9rVTR3R0VUeHMyaTdPVk9VditHRjNX?=
 =?utf-8?B?enBnWTBWNTJwODY0Z2xOKy90akpaMkhiMkZQV0xDd3RYTlcwd0RNWHQ0b2pq?=
 =?utf-8?B?V0V1Y0lBVThYQmg3Z1RaVk9UTFlyREp1QzZqUUJtajVBczNXWTRRaHFXb1Vu?=
 =?utf-8?B?Unc2dzhXUU55WDdVRnlONHo5b1BiREtwYUQ1ZmtHNDBVOUFrWC9lMjFWR3Mx?=
 =?utf-8?B?aFhlaGs1L3h4M09IbldmTFpkakcralYzcnpMNWwxQThSWGdBd0VRVXFnbVh2?=
 =?utf-8?B?ZHY5ZHV6dlJDOHVPWHBlVHN6eFdoa3BnbTR2VEFucVM0ZnRBcEQzTmovWGxT?=
 =?utf-8?B?SUFCTHk2RVFuSDhCaENscTVEV2U1MXo4aVhtUEdtYUJoOVg5SGJwT1lqdnZh?=
 =?utf-8?B?Z0dMa1ZLcHlwSHpHZHNhUFZMRXg4WGk4VTJ2RVdLMDducGN5UmRSRzl5OUxW?=
 =?utf-8?B?bjJBbUR3bzNDUlpWOFBCRUY1MUpOd3FHZWlSWmxFVlZYT0lIdXZCYVNqMVZu?=
 =?utf-8?B?c1krekpGTjFxMVRxajRaSTcwby9sZjBlN21JSHp1QlhkR3ViMGlQc1ZFcWJ6?=
 =?utf-8?B?YVpjQnl3TDEyb2l0TGFKak1hWVpCdzlWRkRVSGVTY1VIYkNZdmlJVXFPN090?=
 =?utf-8?B?eGwycllnQUlNYk9KbFhoNTNIbGZtQVFMcm1rNmh6QWNKaFd0bFFaVFFxc3k5?=
 =?utf-8?B?UmRnd2dEK3o1eVgyR2hwbmFRSWxOdjRuSERPOXZFU2s2c2p5cnpsVDFrSEpF?=
 =?utf-8?B?MGczWVF5OVh5Nms1MU0wRTFkQUVaRDdOUzN4SWRxbGF1L1Jzckd5WWE4cTUx?=
 =?utf-8?B?M1VLMWtINCtCSGRtTFV4bWgvZEJHTDg2Wkx3b1N6TnlMWXNCTVpGYmdCU3o1?=
 =?utf-8?B?TTcxK2hvOVozQXBxWkdGdndKV2xyZ2t2ZzRzR1RQTEgrL1pWdVVDVWFnTVpY?=
 =?utf-8?B?SFRJZDhxd0h0dVhITjZPNWxUeTVZNUlGTHcvY1RHbEN1MjczdjBpSmFDSkNv?=
 =?utf-8?B?VW1FaXVZNTd0V3dXMUVRb2I2SHdGWDkwaVY5TWN1dFVQVkFvWFl4ODZOUnY4?=
 =?utf-8?B?MWtvNldyTlJGamh6dGpUQlNXYWlLOWNuN3RnRlRqZ0V3N1ZjSjBMam5IV3Rr?=
 =?utf-8?B?VVBuL3RoTkF4RVArTVdaaUh0bUhCQm9oSXdRQWpTOXdUdHlrcU40VDByVnFV?=
 =?utf-8?B?VlZoZ2lub2l1c3JDTXd0L0l1RkhFdlFBZHptWjJGT0E1S0lhMkdFQTVnUWNz?=
 =?utf-8?B?Q0NvWkpNbDlST0hKY2dsZz09?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e075d22-a169-45ec-2870-08dafe0a3009
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB3794.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jan 2023 12:54:53.9599
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: N0DdKUmBQjDNyaV4/rPg50GQXdyBSZHUQYUOxDkCxEz1txE763816kyfc26RKaDxe6WHltpnujqn36jAKfrGhw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR10MB6093
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-23_12,2023-01-24_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 malwarescore=0 mlxscore=0 bulkscore=0 adultscore=0 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301240118
X-Proofpoint-ORIG-GUID: C5mzQXMzL9KozRdI3LMalBUSVulyYtXe
X-Proofpoint-GUID: C5mzQXMzL9KozRdI3LMalBUSVulyYtXe
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 24, 2023 at 05:41:22PM +0530, Naresh Kamboju wrote:
> Hi Tom,
> 
> On Tue, 24 Jan 2023 at 01:12, Tom Saeger <tom.saeger@oracle.com> wrote:
> >
> > On Mon, Jan 23, 2023 at 01:11:32PM -0600, Tom Saeger wrote:
> > > On Mon, Jan 23, 2023 at 01:39:11PM +0530, Naresh Kamboju wrote:
> > > > On Sun, 22 Jan 2023 at 20:51, Greg Kroah-Hartman
> > > >
> > > > Results from Linaro’s test farm.
> > > >
> > > > Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> > > >
> > > > * sh, build
> > > >   - gcc-8-dreamcast_defconfig
> > > >   - gcc-8-microdev_defconfig
> > >
> > > Naresh, any chance you could test again adding the following:
> > >
> > > diff --git a/arch/sh/kernel/vmlinux.lds.S b/arch/sh/kernel/vmlinux.lds.S
> > > index 3161b9ccd2a5..b6276a3521d7 100644
> > > --- a/arch/sh/kernel/vmlinux.lds.S
> > > +++ b/arch/sh/kernel/vmlinux.lds.S
> > > @@ -4,6 +4,7 @@
> > >   * Written by Niibe Yutaka and Paul Mundt
> > >   */
> > >  OUTPUT_ARCH(sh)
> > > +#define RUNTIME_DISCARD_EXIT
> > >  #include <asm/thread_info.h>
> > >  #include <asm/cache.h>
> > >  #include <asm/vmlinux.lds.h>
> > >
> > >
> > > My guess is build environment is using ld < 2.36??
> > > and this is probably similar to:
> > > a494398bde27 ("s390: define RUNTIME_DISCARD_EXIT to fix link error with GNU ld < 2.36")
> > > 4b9880dbf3bd ("powerpc/vmlinux.lds: Define RUNTIME_DISCARD_EXIT")
> > >
> > >
> > > Regards,
> > >
> > > --Tom
> > >
> > > >
> > > >
> > > > Build error logs:
> > > > `.exit.text' referenced in section `__bug_table' of crypto/algboss.o:
> > > > defined in discarded section `.exit.text' of crypto/algboss.o
> > > > `.exit.text' referenced in section `__bug_table' of
> > > > drivers/char/hw_random/core.o: defined in discarded section
> > > > `.exit.text' of drivers/char/hw_random/core.o
> > > > make[2]: *** [/builds/linux/scripts/Makefile.vmlinux:34: vmlinux] Error 1
> >
> >
> > This is also occurring in latest upstream:
> 
> Right !
> build/gcc-8-dreamcast_defconfig
> build/gcc-8-microdev_defconfig
> 
> These build errors started from v6.2-rc2 on the mainline [1] & [2].
> 
> >
> > ❯ git describe HEAD
> > v6.2-rc5-13-g2475bf0250de
> >
> > ❯ tuxmake --runtime podman --target-arch sh --toolchain gcc-8 --kconfig microdev_defconfig
> >
> > `.exit.text' referenced in section `__bug_table' of crypto/algboss.o: defined in discarded section `.exit.text' of crypto/algboss.o
> > `.exit.text' referenced in section `__bug_table' of drivers/char/hw_random/core.o: defined in discarded section `.exit.text' of drivers/char/hw_random/core.o
> > make[2]: *** [/home2/tsaeger/linux/linux-upstream/scripts/Makefile.vmlinux:35: vmlinux] Error 1
> > make[2]: Target '__default' not remade because of errors.
> > make[1]: *** [/home2/tsaeger/linux/linux-upstream/Makefile:1264: vmlinux] Error 2
> > make[1]: Target '__all' not remade because of errors.
> > make: *** [Makefile:242: __sub-make] Error 2
> > make: Target '__all' not remade because of errors.
> >
> >
> > FWIW, the above patch resolves this.
> Yes. Tested and confirmed it fixes the reported problem.
> 
> > How many more architectures need something similar?
> Now I see it on sh with gcc-8 only on the mainline.
> 
> OTOH,
> It was noticed on earlier stable-rc 5.4 for x86, i386, powerpc, sh and s390.
> 
> git_describe : v5.4.228-679-g79cbaf4448f3
> kernel_version: 5.4.230-rc1
> 
> Regressions found on sh: [1] & [2] mainline and below
>     - build/gcc-8-dreamcast_defconfig
>     - build/gcc-8-microdev_defconfig
> 
> Regressions found on i386: [3]
>     - build/gcc-8-i386_defconfig
> 
> Regressions found on powerpc:  [4]
>     - build/gcc-8-mpc83xx_defconfig
>     - build/gcc-8-ppc64e_defconfig
>     - build/gcc-8-maple_defconfig
>     - build/gcc-8-ppc6xx_defconfig
>     - build/gcc-8-defconfig
>     - build/gcc-8-tqm8xx_defconfig
>     - build/gcc-8-cell_defconfig
> 
> Regressions found on s390: [5]
>     - build/gcc-8-defconfig-fe40093d
> 
> Regressions found on x86_64: [6]
>     - build/gcc-8-x86_64_defconfig

v5.4 needs:
84d5f77fc2ee ("x86, vmlinux.lds: Add RUNTIME_DISCARD_EXIT to generic DISCARDS")

which didn't hit Linus's tree until: v5.7-rc1~164^2~1
This explains why v5.4 blew-up and v5.10 didn't.
 
I'm testing the following for v5.4

84d5f77fc2ee ("x86, vmlinux.lds: Add RUNTIME_DISCARD_EXIT to generic DISCARDS")
This needed a little massaging to apply.

99cb0d917ffa ("arch: fix broken BuildID for arm64 and riscv")
4b9880dbf3bd ("powerpc/vmlinux.lds: Define RUNTIME_DISCARD_EXIT")
07b050f9290e ("powerpc/vmlinux.lds: Don't discard .rela* for relocatable builds")
a494398bde27 ("s390: define RUNTIME_DISCARD_EXIT to fix link error with GNU ld < 2.36")
+ the arch/sh patch https://lore.kernel.org/all/9166a8abdc0f979e50377e61780a4bba1dfa2f52.1674518464.git.tom.saeger@oracle.com/


I'd be grateful if you could confirm - so I can send this full series to
Greg.

If you'd rather - I can send the patch-series now for testing?

Regards,

--Tom
> 
> 
> [1] https://qa-reports.linaro.org/lkft/linux-mainline-master/build/v6.2-rc5-20-g7bf70dbb1882/testrun/14340424/suite/build/test/gcc-8-microdev_defconfig/history/?page=3
> [2] https://qa-reports.linaro.org/lkft/linux-mainline-master/build/v6.2-rc5-20-g7bf70dbb1882/testrun/14340393/suite/build/test/gcc-8-dreamcast_defconfig/history/?page=3
> 
> [3] https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.y/build/v5.4.228-679-g79cbaf4448f3/testrun/14304065/suite/build/test/gcc-8-i386_defconfig/history/
> [4] https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.y/build/v5.4.228-679-g79cbaf4448f3/testrun/14304362/suite/build/tests/
> [5] https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.y/build/v5.4.228-679-g79cbaf4448f3/testrun/14304530/suite/build/tests/
> [6] https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.y/build/v5.4.228-679-g79cbaf4448f3/testrun/14304610/suite/build/test/gcc-8-x86_64_defconfig/history/
> 
> stable-rc report on 5.4:
> https://lore.kernel.org/stable/Y85tO%2FmJOxIaWH4c@debian/T/#m6b1fdc9bcfc15944e26e3cdd6b1310c878251999
> 
> Best regards
> Naresh Kamboju
