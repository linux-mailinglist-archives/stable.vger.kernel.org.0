Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5F2C6785DC
	for <lists+stable@lfdr.de>; Mon, 23 Jan 2023 20:12:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230486AbjAWTMS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Jan 2023 14:12:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230428AbjAWTMQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Jan 2023 14:12:16 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D5D13AA2;
        Mon, 23 Jan 2023 11:12:15 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30NINpbK020610;
        Mon, 23 Jan 2023 19:11:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type :
 content-transfer-encoding : in-reply-to : mime-version; s=corp-2022-7-12;
 bh=D9BsJFQGE+gDPlb3wyiHp9TaMDyg6F2gY4c5eaeYYnc=;
 b=V9WovIIoWu01EX79kGJsRiSSltrVQYECXfqaYnW2X/fzsRtF03y5SIMpvf4DZLgqoYVZ
 LTdTwT0uqEIInI+mapJaHUEaIkinSrrnwsEZypzifdkPe4onshArIpp55Wj61JHYDaeX
 d5DJDlyuswkhYg09QHaMDHTXR61Dpvg/ZW104jVA+e4ELyNmf3kIv1ADtJ/gDYdHjoDf
 5HiTLkIUB1bt2n5MyEx/woh1Gtt8Cp0FSt7ufSmdg/TtDze8uoIEnmLMohzbpPMK4Tdx
 xYE+9diSG8hDS1GVOGKbr1a4LH9Nk6W6OihSchrqOyRAfgdmxtR4ZTzKGggaKouqZ7bK mg== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3n87nt3mhk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 Jan 2023 19:11:35 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30NJA4LX023264;
        Mon, 23 Jan 2023 19:11:34 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2171.outbound.protection.outlook.com [104.47.57.171])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3n86g47vxk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 Jan 2023 19:11:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DwjbNCDTs+o2UqY8+4N+g4Je6N5vtVQr3hYvIvnS0CNS3po19CqwPk4EkKWRtQzYBD0i/fRLbOcFUKPIrV3I4LvWJ3wuqXrr9jrvwDrPb+kb1P8iNWP0M9HKMhIA8Tto56eE3pTDMHFxWNQzZHFs6kWCEYuU2ZEzV5saZO24wX7Igw2A7dawoCbEtR4qv4oE/Yjz8JAji5s2NPMegKSsDPVgwS3eQ1SOTed6czKb8e/Ualwy0a4qKmPXkoxbvZEF63HagTcDwT6yASjIF3Ia9W22Dme5d8QqDbhyQLuqwAvorCjO/D5tOUcx8GxKTgVSd1ytDFTIx3V3YSLIaMTCmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=D9BsJFQGE+gDPlb3wyiHp9TaMDyg6F2gY4c5eaeYYnc=;
 b=ocl/VQTH2VXfsYUoj9arPyM4rjabXQJ5E4gGkFBr+inBQc9bhxxyn+cF98X2grC2g/+Xp4rcMr7thMo5/Nf7ehnEfRMNy9AZASpWNSTl6z0p/0AuhMzb6iW/IHXayspxvrj9L5IIBjwUU0JJ+bvY7Me+pb2YrMiBIhxITgADUswzl9TzT+krbSSqKxmNeUXK9eAeLxQoP/gO5PAhH/7aHu+2GjjwqdZ3S53W7AKdcZTzUINXM8Vh+xZ4IvaiOxmmI5LFjGE5WVpbySMt0PqcQK65JY0KkFm5NJFG0zUVyWqddpeE1mawDjCns6ibkf5uPI+AoGjKUDUJf2Wk23ueRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D9BsJFQGE+gDPlb3wyiHp9TaMDyg6F2gY4c5eaeYYnc=;
 b=YU1qbml4j35hrG5UpufMI5WwMxDjVJxqS881dRFBVHrZz7TLKekMkMiLlzPbNV6ECaUD8W6Or7cZa6mFuIzBQqh9W/GKkgKv44RS2nH/h28mDe5rs4vHu2q17bcU/MppHo6MJ80h0UNwSG+KOXJV2QZgSBmGkxS5mNJCp0kwqWs=
Received: from BY5PR10MB3794.namprd10.prod.outlook.com (2603:10b6:a03:1b2::30)
 by DM4PR10MB7426.namprd10.prod.outlook.com (2603:10b6:8:183::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.12; Mon, 23 Jan
 2023 19:11:32 +0000
Received: from BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::f37e:ad45:7d9e:d84d]) by BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::f37e:ad45:7d9e:d84d%6]) with mapi id 15.20.6043.014; Mon, 23 Jan 2023
 19:11:32 +0000
Date:   Mon, 23 Jan 2023 13:11:28 -0600
From:   Tom Saeger <tom.saeger@oracle.com>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
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
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 6.1 000/193] 6.1.8-rc1 review
Message-ID: <20230123191128.ewfyc5cdbbdx5gtl@oracle.com>
References: <20230122150246.321043584@linuxfoundation.org>
 <CA+G9fYsS1GLzMoeh-jz8eOMbomJ=XBg_3FjQ+4w_=Dw1Mwr3rQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+G9fYsS1GLzMoeh-jz8eOMbomJ=XBg_3FjQ+4w_=Dw1Mwr3rQ@mail.gmail.com>
X-ClientProxiedBy: BY5PR16CA0020.namprd16.prod.outlook.com
 (2603:10b6:a03:1a0::33) To BY5PR10MB3794.namprd10.prod.outlook.com
 (2603:10b6:a03:1b2::30)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB3794:EE_|DM4PR10MB7426:EE_
X-MS-Office365-Filtering-Correlation-Id: 9d8f4b9b-f5de-49dd-d267-08dafd75a35b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yP+rt8lS8Rzd9ryO63HF3Dz1zqOC5gybX+azoUjh809+ejDVOSC/sgyeF2f8WWSfFf5+W1ZM8R2heoOooQGFkiL2UXqUTgpBHqXj6rN39XTRWFWlpQVL5PiWmttoZxxWGZyjUkmUYqtsdUMIzjjM+1bBH0LZ+hwESRcTB9QPL4RrWY+/nHoeq/yRtHb5mDFTiErHl7EmAA8i/w3PIGCwe5J8AU7hZzkIIWLV7bUdURbwqhWJUhII2oDMQoiYgvvIEOQjZvTgHGr/jX1DKdFwspnhzMi/tpRQcvlCqip1tL24rsavHX35v2EZWPHE8h/BjIuXsKjGVnTIwzYyH//rC6od1g/mfuIPbMUSTuTRek+GOgdNcjL80oRgFOBmxhUuZK63ELbUX+2pvL+qNhTarZtm0jdbjCCEt1JD18aw8cMI7zqXuggZnrRwWnYKyZlP75MOVj9zyLGhW/nhyx9wPh0sqoL1OAYDQ58mx6hiYD1Tm0SK+6U1LRWUWPdZQmoyZHnagKbcxDIDeFDNHUwPfjAwAowTjmd07MrNhuRhnQSK/KTBKLIlXT3xxZUnLsDl6XGYaUE0j+Vnc4H9FngaekzUVU2FqEfXnRWaVnarXEiC8r6armc1MZY3JEMDHH1tJkM3OMwcRSKaSVRSUGxkqLwIS+K3LGYebLHN+yndF1nXFbWAlkyKuA4ef5pFWgETWTKEm9u0y+jl5tBm/7Rjhw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB3794.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(376002)(366004)(136003)(39860400002)(396003)(451199015)(36756003)(8936002)(66946007)(86362001)(8676002)(66556008)(4326008)(44832011)(6916009)(66476007)(2906002)(7416002)(5660300002)(38100700002)(6486002)(478600001)(966005)(316002)(54906003)(6666004)(41300700001)(6506007)(26005)(186003)(6512007)(1076003)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YWkrV0gxdnhxT1JWZWI0amhJOUJhMW40ZkQ3N2s5eXdOb1RJcDlHM0FrTlJI?=
 =?utf-8?B?Um0yL0oyWldCSGxzSGN0MlpxNUNpeDNVV2JmazIzeStraWZDOE9GTk5UZ0pD?=
 =?utf-8?B?ZWZJeG1vTkhBQVl3U1pabUlSOGhNZUVFWk1OSS9WMUZ0Y0FpalQvMXNoQ0dU?=
 =?utf-8?B?NDlzTHIzK3FaNkNLQ2djOUpBZkFXajJwbXhNaTRKK1ZqVHlvMWFJdGUrNE03?=
 =?utf-8?B?L3dob3NoRW1jNm9aN1VQTnlPeDJwekcxdlpZUHQ0UWpXNlNHaS9JSmhKaW5D?=
 =?utf-8?B?d1NVZUJBWGN5dEhWR29NZkpQdEZGNERpZk1SR2haU1ZIRTVhVTBlcUp0a2tm?=
 =?utf-8?B?MDFRVDFTN29UUjJmc2tnTjNvQ2V1YlNocHJxRTVtYUFXZ1ViazFGQWFGTWlN?=
 =?utf-8?B?TTI5b1FTdnRFVDVkSXN1OHYzN2w2ZWo5NmRkVjNnd2Q5d09wUUdweDVZc25P?=
 =?utf-8?B?Ly9sVGNPbXR0QXNxeFhTUUl3cU5SM2hocEtUZy9RWElCV3BxSU1IaFd6T2Iv?=
 =?utf-8?B?WlF3M052TVlVMkRlUlZHai9EUUxqbWYxdWFxQ2JvbDNKcTQ2UUFNMDFPQ21B?=
 =?utf-8?B?Uk11L0MyaEpaTXRGZHBnT2JIS25taFdBS29vQmdhcnhnVG9lNUt4UDFpNDFK?=
 =?utf-8?B?TmVEcHNMSmhZdENublJUL2I3TlBOYnl6L3ZoZUdrYkhnMVdlbHpTUnBPaHpQ?=
 =?utf-8?B?cHliZVQ1TjZucy9IcWpJMUxwYnM2dzVkVk12MDZhUEtSUXVjcUFzamZKMml1?=
 =?utf-8?B?QlNoWVduL09qVlFFSkJkWSthK2x5WjJOdDY5M0YvQWt4NjM4dzVaOTZZaWVu?=
 =?utf-8?B?TDR6ZjFQZXloUHBTZm4wR0todmd0cW1FY0N4NzErOUk2S1U4eFJqWW9jdzFv?=
 =?utf-8?B?czBwcjZ0Zk9NMnNSQm0zSjBHNUxFaSt2V1UxbTFZOVUrdHlzUjFVZUladVVw?=
 =?utf-8?B?MGxjTGY3REhRWGlpRlBWWVo2SGNRemVJRXY3WEU2ZUhobEFzQU5VNWxrZVpD?=
 =?utf-8?B?U0NPalh4clJPT1hRTExhMTdadUJWdmFTOGFtM2tJQ0FEY3MrNXFUZEFabjht?=
 =?utf-8?B?dU1HcVVibjN5WUluN2FKOXppVWhHYkIvYTdLQmJxR0hIRERQMk9qbnM4blJ3?=
 =?utf-8?B?Tk5RaTVXMG1hSS9xZWxsaWc4Snh5S3EzUXgzR0hzTWk1WXk5UDV4QllMSHcv?=
 =?utf-8?B?bVZkWExtY1RFQ2p0MTg0YXZGZFR1a2p5RlU2QVFTczlqRG9qdkxEQ3AyT3lt?=
 =?utf-8?B?RVZnM1grTTc5bEJIRitUYzVBMEtEQ09tU3BhT0M1YUhKbnRnRnhucGk1S2dX?=
 =?utf-8?B?bkVtUHN3WkhMSUt2UTdoVUp6cTJ4cG1URlZYR3NpdWxoMGM4WVRzRWFSY3Ay?=
 =?utf-8?B?dU1kbjlpdEZsL2lueVJTUnR0Rkx0REdOUXVZUGZTaFBKRmh6b3FReS8zbWVJ?=
 =?utf-8?B?UDduZko1cnNaT2FBamNyY0dqam9saEFUQXRIUUwyVG5wMU1rRkZOWVUwbGNB?=
 =?utf-8?B?QjJlY3NYNDE4dHEvS1NaUjJUY0FlUjl3a280VFFacDZKc0VZZE5IVFRYbm13?=
 =?utf-8?B?MlZXRkVGdldqZTdnbjV4d3dtd2RuQlhNcEJubWxONU41dTBXNU5pRkNXRmc2?=
 =?utf-8?B?TjVGUnByOGlZcUdtTUd1Q0NScFArQTA3Uk9laExDb1R3bXo1Q2JYWUpiekRu?=
 =?utf-8?B?anJxNlUxQTF4Ym5ENlRPYXo3NmEvMElrZEduTE8zQmhKSk16anpyNTlweExm?=
 =?utf-8?B?ZXN5VXlIbndSeEdLUm9PdHF6bTBURjlSYi9FQlp3cmlLMXpiTDd5R0NFTkR4?=
 =?utf-8?B?aUFnY2FqeEtXUmt2citTQVQ2MW51aFVyMUpWRE9FS1h6bmZqcnhad0wwNlNM?=
 =?utf-8?B?d0VZK2RTNUJJV2YzMDc4M1NVQ0VmN1FHWTJxRkRjSzdHQXZVRnEvZUpRc0I2?=
 =?utf-8?B?dXdMQVRyZ3E4ZVhyWUlvbG9Mb0hKd21oN2RGa3c5akJ5ejZyZXo0TkE1aWZz?=
 =?utf-8?B?bTFhdk5WRjJLMmF5OVNMVkVoTFJETjNYdDh2VjFPeFF5TVEvM2FGS2UvSElS?=
 =?utf-8?B?YWpIMWhZTTZ4aHF0OHFYdGNLTzFQdHRUNmZwT1lzZTdPRHcrYTlTYzBDZFAz?=
 =?utf-8?Q?EpU88tsu560qg5n1jozSFbcf1?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?cldOQ1FyNmpMTkJLd0hTbnNEd2tDRXFDb0pGS3QyK25JemY3NXV6R2MzMi9N?=
 =?utf-8?B?d2dZV0JkdnFOdFNRYTFWWVZWWHgrNXVzcGZlUmNDWFdnK3pwZkdZT3Y2RzJ2?=
 =?utf-8?B?Y3MyODhjNEFFYzhmV1hRc3phejRUalF1cFFRUjMyUUNPNitZQVRaM21ZdTZL?=
 =?utf-8?B?dHpUdzdJU0JoTnBtakxLTnpwcFlIVFFKN2RvM2E3a05qemJGeFYwdjl6K1kr?=
 =?utf-8?B?TXl6WmFiVnZNRzdjd0V2MEw0Z2tPVXlqSWpSVmw0dXdXdTlra2ZmMlJGY0U1?=
 =?utf-8?B?UXNVOERta2liZFVZaUJaU09DZ0ZzUFZpQUNZblp0SXFWblFXdUdYcXpqUWhp?=
 =?utf-8?B?eWtGYUtzQ1RJRzhjbWtXMjAyZEZoUm41aktFdVh5TmRFYTh4NnZ3SGZzOGxo?=
 =?utf-8?B?UFRBc2s2alIzTVRxL0I4YTd4b3dBc2UzZkNJTFdPUDhDVTJ5OFRNM1pnVUZs?=
 =?utf-8?B?QXhxeWF6NnlOVE50L1M3M3EwN2RPS2RtdGk0bSsyR1RFV2pZa1p2a2cxZnpi?=
 =?utf-8?B?ck1MQ1R1RTlLOVpJSUF6eWxOYzRxR2JLekNhS0prWjFudC9qTEVvQTM5aGpV?=
 =?utf-8?B?VlM4UTJudDBBMGVHbjR2ZEhPdDFUUzA4RkQ4TjV1eWMyN3NGRDVrK3hkVEJh?=
 =?utf-8?B?eVJEMDlld254aTZVV21YSU05SThDdmQ4bXJ4WmZpK1VFRzk1Y2FVL2Q3MXJW?=
 =?utf-8?B?OXYzTWE5aTVRM2ZxRC90TEJaaVBmRCs3YnJzaDkrT3hCZHA0SXFCQ3RSTFJ4?=
 =?utf-8?B?NVM1aE1keEJNM2dSS0YzSTBOUWFXaDMwR0JISXZUZlJ3UktXNTZvRlFSZVVl?=
 =?utf-8?B?N2tsWFYvN21zbCtKRHN2NTMwdUo5TEdYUzZvdkhIUC9nV1loWGQwTGJoR0tm?=
 =?utf-8?B?d2xsM01jSjNSRG1FMVJjd0FKTy96bEpUblg5V3cra2JKV1NhU2R5R3N5b1I3?=
 =?utf-8?B?SVZpanFKZmNuUFI4aDhVL213cythbjh6Nm91WUZSSUczSFRsYmtrZjFUWDlM?=
 =?utf-8?B?SWZIVlJhN2I5OERDTTBKUjliOXBPTU5wc2g5RlBZQ1R0MU8zQlljR0ZPTFBQ?=
 =?utf-8?B?cEFVV2xrY1lpWFFNUURReXN6MjN3Q0x1amxFbmM1blpBZjZCQ2hyTnI4cmJQ?=
 =?utf-8?B?eTBiU2h4SHUyb1cxN2kyMjh5UXVrQ1MzdXBrVDQreENNZlY3aGJxTFA3cVRO?=
 =?utf-8?B?N1R5T2JuTEswbFgxQ1dpcWtublNXNWtzSERndll5SmZWVllyek80bnI4d0NK?=
 =?utf-8?B?K3FOY09EZEFwd013a1NPYlBJZkxYN0dIeFNVU2tFMFB3U3NVWXNZdjF6cGxj?=
 =?utf-8?B?UlZZZ214VnQrdTJCMGFtTUQxRW9pSU9VM2tDbUw5QVdBNWM2TnVWTjF0NUJG?=
 =?utf-8?B?cVp6b25menpqNldkYm51cWF0ZnE1WHBRYXI3YVpPMHNHMW53cng0MVkvZVBT?=
 =?utf-8?B?NENJV0VmQVZkUlNXdlI5U1l2NHdhSUloZmY1V2QydzVISlpwYmJ1bnA2MXhI?=
 =?utf-8?B?RVZ5ajVhb01RRzJLWWZlMnpaLzRKOU1HQ2dBZHBWN04vNWZsanRHajhJc2Vt?=
 =?utf-8?B?R2plRjFLbVpnaElhT2FmOWt0dFlCcWdqbU1CZzNVakw2TWl1ZEhqVC9ET2Iw?=
 =?utf-8?B?eVRIaDRBT05iU29zeENOWTBkYUZhV05BbzJxWWpsYkZuVkp5SmgxYU5RaHFV?=
 =?utf-8?B?WFR3L3MyYm1EOXRzajAzdWM5NkQ1VGJnd1Q1SER2UlZ1a3hCdUhzaFd5QXRW?=
 =?utf-8?Q?C5i33qHjHMSl0i6t74=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d8f4b9b-f5de-49dd-d267-08dafd75a35b
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB3794.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2023 19:11:32.2863
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cH5/jTYxlD2vJYx5bvuvBxgoH4YRUAnDLRh72NBoHOK77W6y/+/w7MeNTTf1a+EHPLoEy1BWh4imarYobi/qsQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB7426
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-23_12,2023-01-23_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 phishscore=0
 suspectscore=0 malwarescore=0 adultscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2301230184
X-Proofpoint-ORIG-GUID: _GX37GoGzHjrMNnUsfds2riH8kh_gxOo
X-Proofpoint-GUID: _GX37GoGzHjrMNnUsfds2riH8kh_gxOo
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 23, 2023 at 01:39:11PM +0530, Naresh Kamboju wrote:
> On Sun, 22 Jan 2023 at 20:51, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 6.1.8 release.
> > There are 193 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Tue, 24 Jan 2023 15:02:08 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.8-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> 
> 
> Results from Linaro’s test farm.
> 
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> 
> * sh, build
>   - gcc-8-dreamcast_defconfig
>   - gcc-8-microdev_defconfig

Naresh, any chance you could test again adding the following:

diff --git a/arch/sh/kernel/vmlinux.lds.S b/arch/sh/kernel/vmlinux.lds.S
index 3161b9ccd2a5..b6276a3521d7 100644
--- a/arch/sh/kernel/vmlinux.lds.S
+++ b/arch/sh/kernel/vmlinux.lds.S
@@ -4,6 +4,7 @@
  * Written by Niibe Yutaka and Paul Mundt
  */
 OUTPUT_ARCH(sh)
+#define RUNTIME_DISCARD_EXIT
 #include <asm/thread_info.h>
 #include <asm/cache.h>
 #include <asm/vmlinux.lds.h>


My guess is build environment is using ld < 2.36??
and this is probably similar to:
a494398bde27 ("s390: define RUNTIME_DISCARD_EXIT to fix link error with GNU ld < 2.36")
4b9880dbf3bd ("powerpc/vmlinux.lds: Define RUNTIME_DISCARD_EXIT")


Regards,

--Tom

> 
> 
> Build error logs:
> `.exit.text' referenced in section `__bug_table' of crypto/algboss.o:
> defined in discarded section `.exit.text' of crypto/algboss.o
> `.exit.text' referenced in section `__bug_table' of
> drivers/char/hw_random/core.o: defined in discarded section
> `.exit.text' of drivers/char/hw_random/core.o
> make[2]: *** [/builds/linux/scripts/Makefile.vmlinux:34: vmlinux] Error 1
> 
> Bisection points to this commit,
>     arch: fix broken BuildID for arm64 and riscv
>     commit 99cb0d917ffa1ab628bb67364ca9b162c07699b1 upstream.
> 
> Ref:
> upstream discussion thread,
> https://lore.kernel.org/all/Y7Jal56f6UBh1abE@dev-arch.thelio-3990X/
> 
> Steps to reproduce:
> # To install tuxmake on your system globally:
> # sudo pip3 install -U tuxmake
> #
> # See https://docs.tuxmake.org/ for complete documentation.
> # Original tuxmake command with fragments listed below.
> 
> tuxmake --runtime podman --target-arch sh --toolchain gcc-8 --kconfig
> microdev_defconfig
> 
> Build log links,
> https://storage.tuxsuite.com/public/linaro/lkft/builds/2KgeCQc3ZdltaEFoi0CwyJlUcuk/
> 
> --
> Linaro LKFT
> https://lkft.linaro.org
