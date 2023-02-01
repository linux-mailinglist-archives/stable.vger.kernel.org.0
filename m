Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79B25686EA1
	for <lists+stable@lfdr.de>; Wed,  1 Feb 2023 20:06:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231420AbjBATGG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Feb 2023 14:06:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbjBATGE (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Feb 2023 14:06:04 -0500
Received: from mx0b-00230701.pphosted.com (mx0b-00230701.pphosted.com [148.163.158.9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA83D11666;
        Wed,  1 Feb 2023 11:06:03 -0800 (PST)
Received: from pps.filterd (m0297265.ppops.net [127.0.0.1])
        by mx0a-00230701.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 311G1gkk017681;
        Wed, 1 Feb 2023 11:06:00 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synopsys.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=pfptdkimsnps;
 bh=b55n0wPBdBwP4oM7kji50SvHtSzFudIfnLhQN1qIKRk=;
 b=DKZie12zSOaqwauGAnJltOgkRaoWxUUsliacDvtaw6GhPq+D0n4Y5XIHygsnDNs7HrCN
 7SWVxt3zrzkdTRSRff8gTs9ErQZXJ4mi6hnKWp58XF5f1G0d1qy2/TZXLCT4Gv3u/gH9
 unNdm9Y9B81Bj+BBZA4QjvE0B/uXswcwA5lam1wn6EPGnDFJPfEd7oIjvyfYaV7Th0Kp
 lKom5OwYjRzylTdUwKmi6fBRPf2XDnIAhH+pcBcJhn+JKRiM3x21zJ3zSYjoNxW/PD6p
 qbEEYLGKFCfLLyAmc08OWyHc0/eUe75c43XyiZPic/WVWZ0nah5PzMSwX9ixquehna8n pQ== 
Received: from smtprelay-out1.synopsys.com (smtprelay-out1.synopsys.com [149.117.73.133])
        by mx0a-00230701.pphosted.com (PPS) with ESMTPS id 3nfp8kkhdp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 01 Feb 2023 11:06:00 -0800
Received: from mailhost.synopsys.com (us03-mailhost2.synopsys.com [10.4.17.18])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client CN "mailhost.synopsys.com", Issuer "SNPSica2" (verified OK))
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 564834007B;
        Wed,  1 Feb 2023 19:05:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1675278359; bh=b55n0wPBdBwP4oM7kji50SvHtSzFudIfnLhQN1qIKRk=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=DnGO/PkmoYWBoRWGNmKjgKJfQvWIbCgGBVA7iBmEhnwETQt7SYE05J1Ffsz4fxfIA
         fBGBTulPXTZ6z39EqQWsDYPzm85AGSKua4JIk1CtKBK1BVYT1g0+tMHmBS1GlBipez
         ARllfxeHHxpGeO88jf8lo6+sApW5XPEIvxJFyMqxecYAXCIXX9F9JBWtrMEAlxBB9y
         a2mBdGGWfx0kSvLuSVnxXb4yQbS4RhS5s5Q4qFCoOPtQfjjzNvNvLCbyoqRm5eIsmp
         6kmXXNmnVx+9VPoJ7Vu+4ntvgdaQrnkrHGoyGmYaUZBKa2v3KKbMofPWP43jm5CqZY
         vJ/KwT6IIjGdw==
Received: from o365relay-in.synopsys.com (unknown [10.202.1.137])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client CN "o365relay-in.synopsys.com", Issuer "Entrust Certification Authority - L1K" (verified OK))
        by mailhost.synopsys.com (Postfix) with ESMTPS id A0E19A0062;
        Wed,  1 Feb 2023 19:05:57 +0000 (UTC)
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2109.outbound.protection.outlook.com [104.47.55.109])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "mail.protection.outlook.com", Issuer "DigiCert Cloud Services CA-1" (verified OK))
        by o365relay-in.synopsys.com (Postfix) with ESMTPS id CCC2C40065;
        Wed,  1 Feb 2023 19:05:56 +0000 (UTC)
Authentication-Results: o365relay-in.synopsys.com; dmarc=pass (p=reject dis=none) header.from=synopsys.com
Authentication-Results: o365relay-in.synopsys.com; spf=pass smtp.mailfrom=thinhn@synopsys.com
Authentication-Results: o365relay-in.synopsys.com;
        dkim=pass (1024-bit key; unprotected) header.d=synopsys.com header.i=@synopsys.com header.b="bi7LQ7q3";
        dkim-atps=neutral
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hVz09d7dHXklwEOH4f+FmqdyjTEd1XOEMG/jXw0/TXpxWBgQFaSH+bGcg5pE5XXlgo+nOPDl88wZ/GA9Gf3BviRTGUnZhtpLsBF8KfbEJUSOd5fPDH07Ra34I4c4Sih5MvDUZ0l9u5LiQ4Ur/uUS0M2s2Bq76rpmIoirY8aUH1qZ8pLRx3Hd5ocJNuiW8Nf0rpkqTXYsNAwzUyLYPxqsbeYh3mRVmWlSIjSR/jNOhx5IDwcevpN2x9A2MBATgfTWtwaprBCnPrtTQ6+X3HK5fBfrlcS09gVOL0pK0klJijPYAkdrU/ixaTVnjtqL1AIyjIl4HNhCI1PPpSDiT0v0Hg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b55n0wPBdBwP4oM7kji50SvHtSzFudIfnLhQN1qIKRk=;
 b=QAFSc2ZtN8upzxrXjSmERpDB+jx+x3gRoy/+VPdQA4uKckO0TZ4s+DGc4cHDM9d7KtGhCKyx1RTNb8I7jj9bEFR7yK/QpWTaPBrK7X+LHgwW0eMux1SFd0/y86J9qRaGi2hgzurnWvmnEOkYRwaHtoU628AimzH49LB9ofNDp2Ym7yka2HSpV9b+DdjbI7BjwUSYRmW5bJxBtmzD1f1Bl9377/BxvlT9b3atDupZwoQ+x00KgospwetRQv5kZ0BklFwZj8AeGxVDu4b/k1ldMz6DJsk4wCYU71VAaSBrncdLzTa1ci7icy24KZxE3G199NHI2WycKODEtvrdCnwr/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synopsys.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b55n0wPBdBwP4oM7kji50SvHtSzFudIfnLhQN1qIKRk=;
 b=bi7LQ7q3KgqQ3FUw7tlyQK+e7HXPxyOpoKEeSOSdMZUoBIFoZRSr1BSs+RGDz4Ld3daaoy00HQs86QvyE8fo3WUj352xMHwm4ycD3T4nqZ90wG2pKqhQsQnw6/G1i+yF4AD+XwGWroRvYkHWN9vHn8uOXea4pGcPgS4emy3I24I=
Received: from BYAPR12MB4791.namprd12.prod.outlook.com (2603:10b6:a03:10a::12)
 by DS0PR12MB7826.namprd12.prod.outlook.com (2603:10b6:8:148::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.25; Wed, 1 Feb
 2023 19:05:54 +0000
Received: from BYAPR12MB4791.namprd12.prod.outlook.com
 ([fe80::6f3c:bd8e:8461:c28c]) by BYAPR12MB4791.namprd12.prod.outlook.com
 ([fe80::6f3c:bd8e:8461:c28c%7]) with mapi id 15.20.6043.038; Wed, 1 Feb 2023
 19:05:54 +0000
X-SNPS-Relay: synopsys.com
From:   Thinh Nguyen <Thinh.Nguyen@synopsys.com>
To:     Linyu Yuan <quic_linyyuan@quicinc.com>
CC:     Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Jack Pham <quic_jackp@quicinc.com>,
        Wesley Cheng <quic_wcheng@quicinc.com>
Subject: Re: [PATCH] usb: dwc3: update link state when process wakeup
 interrupt
Thread-Topic: [PATCH] usb: dwc3: update link state when process wakeup
 interrupt
Thread-Index: AQHZNetg1e8bWR5O+UmEKJODDDA7p666dI4A
Date:   Wed, 1 Feb 2023 19:05:54 +0000
Message-ID: <20230201190550.jozzrvwdi5lcwtbo@synopsys.com>
References: <1675221286-23833-1-git-send-email-quic_linyyuan@quicinc.com>
In-Reply-To: <1675221286-23833-1-git-send-email-quic_linyyuan@quicinc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR12MB4791:EE_|DS0PR12MB7826:EE_
x-ms-office365-filtering-correlation-id: fd9d50a0-8a14-4b52-454c-08db048757ca
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1uBFC2Ee0UR6PwzhSPmc0BaK03SsGxpCIbAtRYtK37z+3vKGGOisJgJQW6Gf6jOIg53QfFppSBLbGqFLi/G6/zYUlWivvHGOclTElhpwKCAxMTqoPmf0/zo5PfQuHgzIQGFEgohEK+buUZha+NWN4umTfZnVCptY7GppmiFGy0IGMNFxtDjcXIUZuVqP44OW4YA8ihF0T5cB58t9bIswyIPC9HwB0ojg0DU3XeNj9y+nuGz5uEG2fVrdDdlsArM2WjjbtgIPFLrJh70Pocae/4EgIH7TLt+PbN//+7HPA1wd1RUZwmONirRayaqD43HaIz2j9VIuQjoraq2Mav2AvRMpiNBF83uZOdu0x6QT5wzuRrH80i8IzjVOcE9dsNP4X3gjn+oCHDMSQxajIeoc91/wCct39NChiQNbNHRg4uUn6QbZyXm7xjcHi0IjGSwsMfqcEhh0Rtlb6K1phybtG5uofrn4zdfJ3NcUdywukvnjdDl7oIXt9/cik5lBnXjjxasUPrbjLMIRdZF8JflwDkivR675LbZDBf5IPoa3L+Ma8pkszy9dlg9OdUx7LVOosNQdsbW63p8ZnpgWnjcowF99PypaYyMwQrR6ET9ng+kYqBi8vljGLeuELihaEzba1t3ZtSdhfqLtvFdfkZeGAINOE0ezZAsvw5h+BlFQu0jd1cMqNIrduAH815ErNo9C7ZoLRQ35PKYMHdumhtG5gA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB4791.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(346002)(136003)(366004)(376002)(39860400002)(451199018)(122000001)(2906002)(86362001)(316002)(6486002)(38100700002)(54906003)(71200400001)(38070700005)(5660300002)(15650500001)(36756003)(2616005)(26005)(6512007)(478600001)(1076003)(66556008)(66446008)(8676002)(66476007)(6916009)(4326008)(83380400001)(76116006)(8936002)(66946007)(186003)(41300700001)(64756008)(6506007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SHZtNXQzS0ZVQzdWb2VsZDQvOWpxeDlodFNBRHlRQnRRS1VqMmI4MXhzdkNL?=
 =?utf-8?B?cVR1cHNQRFlIdUJ5OWpDY2Z6NEhjdHhMWjFwK28rOThweTUrSHV5NCtHdVh5?=
 =?utf-8?B?cjNIeCtjZlg1ckcyZWNuUEdkNFBFU0ZscUZkMkw5dk5adUV4Sm1JaUJOeExD?=
 =?utf-8?B?WkdtN2dQWGdHTUt1dWMxdkU3TDI1TFlWUDh3Uy8zb1VSeWZuOWhmL05tWjBU?=
 =?utf-8?B?c0JKdFNXUHFYVGhjbkxmTmlpY2w1NTl2RWJvaERkaUlPVkVYaFVWMUVmcURX?=
 =?utf-8?B?RUN4VVB1ajR3ZGtZMisxZFV5b3hON0prd3piYU1JMFE3b09UWXllbjdzeXZY?=
 =?utf-8?B?MUhsR0JnVkszODFHeUlxSTB4Z3REak54OWIyNUtKQ1V4N3IrYS85bWRwSXRN?=
 =?utf-8?B?YkFkeEtJbU01WS83QVU4a2JTZlV4N05NWjZkMW9yL2dKc1pQMkJQWVNxc3VP?=
 =?utf-8?B?TkV1OUtNcStBSTBoZVVRV1lPZ0lMNm42TTNPenpQZU9vNjBMRTZpSjVYTUp2?=
 =?utf-8?B?V25vOHFqb1pKc3BrVzlIeDRRbXE1MGUzOXRVV3h2aktuc3d6N3pqNVdEbkVy?=
 =?utf-8?B?NG9CYkdHS1VBbWRrZzNpRG91eHIvVTFVRDdtS3lWdWIzUUVjM2Y2VGJqbklB?=
 =?utf-8?B?MS9PSjhHMXJmY1VKZFh0bk8rTC9XYXE0S1hEWDNUSEZQemJnVHRpZi9WdVdh?=
 =?utf-8?B?NE8vc1Mwb2V5YzBONE1sKzZSNmJGcTg2dyt1dXplazlSckNPaGw2ZDFES2Uw?=
 =?utf-8?B?S09lTEx5bjZ1SlVrK1VjN3hMV2dSOHM1NWM2ZlV5SUNmVEFvV0E2MTAwd2FM?=
 =?utf-8?B?RHpSeFZHVVNZeDFhUGM0ZWR5T0IyTXpiOHBYSXpLVEN2MldzeUNwUFdLdkg5?=
 =?utf-8?B?R3RtNUVQWHFua1R1RFNvMUsxK2hOWVNqMnNXcm5mZStDa24zZUZnVEVIK2xU?=
 =?utf-8?B?SVB1TGYzeUVDbHc4SXhZL09wcGFKRmdBUjg1djZHMklHTmsyU0ppMVlLSEN0?=
 =?utf-8?B?dElxLy9NNS9TWXpsTE12UmV1MldDNlAzVXN2dXZ3cnIrVzhYcGFlY2F4Y0FS?=
 =?utf-8?B?L1EyMW8ybEhwNWd3REQ3Ri9JUHNnOWVHN21jbno3MGJLQzFPL3M0cWJBWFRG?=
 =?utf-8?B?eXlTQzF6QVUvK29aOHZCWWR0akhUdU9EN2NHTFhmNmlCMFN2QmNpejUrUVkw?=
 =?utf-8?B?SjRMWjFPcCt5RGh0YjQ2eHdSS3FvSmpsTFJsSVN2dDR5ZlRZK0FQM2FCZHRX?=
 =?utf-8?B?M2RVKzI3VG1zdGxZT1J0c29JbVhiYzFWelVmSHRvUnZDMmxiNzltVUN6WVdK?=
 =?utf-8?B?OG9vbWtzRGZJQzlxSm0xRzV6MDJFRmxlNEtWcFVlUDJHUndONEQza1duTWZs?=
 =?utf-8?B?TUZmazBxRUJTOGlibmYrZDE0RHhBQm4xWUJhZHpKUkFHSEJCNnZhSHNudGpK?=
 =?utf-8?B?RU9SK1NPNXdBd25JVjRmbnFwR092bnUxQmlPNFB4UnlIMFlHZFZvQllMWVh2?=
 =?utf-8?B?bVZwcU16K2lhK2xaTmtzR2ZHdG9lTldYU1lrR1ZiV3Nkc0IrSVF0R1IyVGJF?=
 =?utf-8?B?WCtMVHNGNkdoOTIyVkJ0VjY0OFF6c0dhcmJyMUtTWHArNUpuZWRQVEdRR3B6?=
 =?utf-8?B?ZHB4OEN6SFV2dXY1QzJOTEVDUkdhbFRwajh2WnR2RnpTWS9UTXc4WSswVmRR?=
 =?utf-8?B?TERMd1F2VGFNTDhqc1pIbXhxdjVMOTc5NGs3S3hieXcrd0RUT0RreHhGY2dH?=
 =?utf-8?B?ckZZK05lc3FTSUdVU0lsWmZjVnljV2J4cmFVVFFIOHIrOUFKZkNDUGlLUzhr?=
 =?utf-8?B?Z0szVUlITm9sNHIxNk9EWTJzbTM3cllUWDJBM1FqN3p2TnJWTG1DT3poQmZG?=
 =?utf-8?B?clJ1SG5LM2dzRDlDYkVJRG9tL1BUN3E3RjhrQUhkK2FzRXppbTZJTElNN1Y1?=
 =?utf-8?B?MEVVaEVkWkxnNjFNYU9tSU84YVNzd3RMeVNqb1Q5TGNjYzZJTTRZZ21aNGNi?=
 =?utf-8?B?MFpHd1J1c0cxYXNkeTJjMXdsQ2hESk1NUnFOR1Ziamdmc3U5V2xsMGVCWXhu?=
 =?utf-8?B?WEFGOFRySVI4WWY1alNmdXNSbmhMTUdtR1ZHZFZQbFF4MjV4V2ZuVW1aRGFR?=
 =?utf-8?B?eXNxbVZwMVBMTWxIaW5rY09uQlJGZko4ZFI3bWs4ZVpWL2ZhTmV5N2crT2l0?=
 =?utf-8?B?L3c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A8E15F7AC8544B489CF08639CBC908E9@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 6db9oCsc0bqx6KqZZlOCxEB0D5GkigRcYdt8dB/CQfmJgFSjDJnDSQCDnupILSuvkXoJl12I3T/Ke+RIKy7vF5AuyW5m6kZaERWWilk9k5uHAWevpl1wCYv1wfZu9lTZ8/9k6PhgC118x4dWnzH1izuGYkv7gRjdeXSQgS1i0JrShdZdV0ffiqi5z/dCY1GBiDULzRQMy2q+NnLh9OwGFRQrtu8eY+Wm43XaLpfluDjidw+0OB7m3j2lRT8xb1Q0R5Vy2idtxauMIulMzRJR/mSppjBO14w/CtSp5xVF7Gopf8q8wYSnIULhPrUQGc/BqJJQ6iTOyzuZEwuU9NZ4IDOSIDpsP9t+MD/owFrQ1SYC0beTd8Z2JWLaJXEoK4cg8soXi0ipl297x9pQgplKEESIITgWQYpswBSZxV5fpzPmi9K7OIJz5tztFPNQDLklL7p8YYt+28A2+lVaM/43YZBIglG2MgqJ0xOJt6eyPcDEesIXxP84pyRXl+MpA/X9Doy0j015lVgGSQDAXIoX185P7teqlUCWSfG6EQUtr9ktNan7Y4hRsHOONUNuw/bursKlx0iY3Ez6omrHD+LpTtFStQwWAlAey80u7GoctTtxaQLAqn9MzvjmjM3w/dRoeLMauy4rXvFgTYoji9YHPAxZuEyhSWgg7lnBI9Usy20uoOJG6bSx6sSflk0ewg+UnXffbuDr7nY5gagPDFyVr9yDKESZOLloP1AZqZ+SovQASgX9TYJrcKO/ytt3eEuLC2ZJh62eE5sdLVbnBKYMwLnkRIl7g3TTHS/4wdCzS/1Ldbp71qhtdSYQjw2fNaRoAmW3l1hqbIT4ennUPXPfLefSA1iLm/vx91l3epnJptJSw7AhSbHLnrJWG/K968RX
X-OriginatorOrg: synopsys.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB4791.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fd9d50a0-8a14-4b52-454c-08db048757ca
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Feb 2023 19:05:54.2402
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VuqE4u4Ni8CV5qBXWLW4SS10j65n/J4nymbiSbBLPQ8zyxjeUtn5+Epfyu1bbJWHUGdPt/ub+L34ggHGTSmYLQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7826
X-Proofpoint-ORIG-GUID: ATYGAuuvuMGnnOtDEuR4LUkZXH8K6jQe
X-Proofpoint-GUID: ATYGAuuvuMGnnOtDEuR4LUkZXH8K6jQe
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-02-01_04,2023-01-31_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_active_cloned_notspam policy=outbound_active_cloned score=0
 bulkscore=0 priorityscore=1501 spamscore=0 clxscore=1011 suspectscore=0
 impostorscore=0 mlxlogscore=582 lowpriorityscore=0 phishscore=0 mlxscore=0
 malwarescore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2212070000 definitions=main-2302010162
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gV2VkLCBGZWIgMDEsIDIwMjMsIExpbnl1IFl1YW4gd3JvdGU6DQo+IENvbnNpZGVyIHRoZXJl
IGlzIGludGVycnB0IHNlcXVlbmNlcyBhcyBzdXNwZW5kIChVMykgLT4gd2FrZXVwIChVMCkgLT4N
Cg0KaW50ZXJydXB0Pw0KDQo+IHN1c3BlbmQgKFUzKSwgYXMgdGhlcmUgaXMgbm8gdXBkYXRlIHRv
IGxpbmsgc3RhdGUgaW4gd2FrZXVwIGludGVycnVwdCwNCg0KSW5zdGVhZCBvZiAibm8gdXBkYXRl
IiwgY2FuIHlvdSBub3RlIGluIHRoZSBjb21taXQgdGhhdCB0aGUgbGluayBzdGF0ZQ0KY2hhbmdl
IGV2ZW50IGlzIG5vdCBlbmFibGVkIGZvciBtb3N0IGRldmljZXMsIHNvIHRoZSBkcml2ZXIgZG9l
c24ndA0KdXBkYXRlIGl0cyBsaW5rX3N0YXRlLg0KDQo+IHRoZSBzZWNvbmQgc3VzcGVuZCBpbnRl
cnJ1cHQgd2lsbCBub3QgcmVwb3J0IHRvIHVwcGVyIGxheWVyLg0KPiANCj4gRml4IGl0IGJ5IHVw
ZGF0ZSBsaW5rIHN0YXRlIGluIHdha2V1cCBpbnRlcnJ1cHQgaGFuZGxlci4NCj4gDQo+IENjOiBz
dGFibGVAdmdlci5rZXJuZWwub3JnDQoNCkNhbiB5b3UgYWRkIGZpeCB0YWc/DQoNCj4gU2lnbmVk
LW9mZi1ieTogTGlueXUgWXVhbiA8cXVpY19saW55eXVhbkBxdWljaW5jLmNvbT4NCj4gLS0tDQo+
ICBkcml2ZXJzL3VzYi9kd2MzL2dhZGdldC5jIHwgNiArKysrLS0NCj4gIDEgZmlsZSBjaGFuZ2Vk
LCA0IGluc2VydGlvbnMoKyksIDIgZGVsZXRpb25zKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvZHJp
dmVycy91c2IvZHdjMy9nYWRnZXQuYyBiL2RyaXZlcnMvdXNiL2R3YzMvZ2FkZ2V0LmMNCj4gaW5k
ZXggODlkY2ZhYy4uMzUzMzI0MSAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy91c2IvZHdjMy9nYWRn
ZXQuYw0KPiArKysgYi9kcml2ZXJzL3VzYi9kd2MzL2dhZGdldC5jDQo+IEBAIC00MDY2LDcgKzQw
NjYsNyBAQCBzdGF0aWMgdm9pZCBkd2MzX2dhZGdldF9jb25uZG9uZV9pbnRlcnJ1cHQoc3RydWN0
IGR3YzMgKmR3YykNCj4gIAkgKi8NCj4gIH0NCj4gIA0KPiAtc3RhdGljIHZvaWQgZHdjM19nYWRn
ZXRfd2FrZXVwX2ludGVycnVwdChzdHJ1Y3QgZHdjMyAqZHdjKQ0KPiArc3RhdGljIHZvaWQgZHdj
M19nYWRnZXRfd2FrZXVwX2ludGVycnVwdChzdHJ1Y3QgZHdjMyAqZHdjLCB1bnNpZ25lZCBpbnQg
ZXZ0aW5mbykNCj4gIHsNCj4gIAkvKg0KPiAgCSAqIFRPRE8gdGFrZSBjb3JlIG91dCBvZiBsb3cg
cG93ZXIgbW9kZSB3aGVuIHRoYXQncw0KPiBAQCAtNDA3OCw2ICs0MDc4LDggQEAgc3RhdGljIHZv
aWQgZHdjM19nYWRnZXRfd2FrZXVwX2ludGVycnVwdChzdHJ1Y3QgZHdjMyAqZHdjKQ0KPiAgCQlk
d2MtPmdhZGdldF9kcml2ZXItPnJlc3VtZShkd2MtPmdhZGdldCk7DQo+ICAJCXNwaW5fbG9jaygm
ZHdjLT5sb2NrKTsNCj4gIAl9DQo+ICsNCj4gKwlkd2MtPmxpbmtfc3RhdGUgPSBldnRpbmZvICYg
RFdDM19MSU5LX1NUQVRFX01BU0s7DQo+ICB9DQo+ICANCj4gIHN0YXRpYyB2b2lkIGR3YzNfZ2Fk
Z2V0X2xpbmtzdHNfY2hhbmdlX2ludGVycnVwdChzdHJ1Y3QgZHdjMyAqZHdjLA0KPiBAQCAtNDIy
Nyw3ICs0MjI5LDcgQEAgc3RhdGljIHZvaWQgZHdjM19nYWRnZXRfaW50ZXJydXB0KHN0cnVjdCBk
d2MzICpkd2MsDQo+ICAJCWR3YzNfZ2FkZ2V0X2Nvbm5kb25lX2ludGVycnVwdChkd2MpOw0KPiAg
CQlicmVhazsNCj4gIAljYXNlIERXQzNfREVWSUNFX0VWRU5UX1dBS0VVUDoNCj4gLQkJZHdjM19n
YWRnZXRfd2FrZXVwX2ludGVycnVwdChkd2MpOw0KPiArCQlkd2MzX2dhZGdldF93YWtldXBfaW50
ZXJydXB0KGR3YywgZXZlbnQtPmV2ZW50X2luZm8pOw0KPiAgCQlicmVhazsNCj4gIAljYXNlIERX
QzNfREVWSUNFX0VWRU5UX0hJQkVSX1JFUToNCj4gIAkJaWYgKGRldl9XQVJOX09OQ0UoZHdjLT5k
ZXYsICFkd2MtPmhhc19oaWJlcm5hdGlvbiwNCj4gLS0gDQo+IDIuNy40DQo+IA0KDQpUaGFua3Ms
DQpUaGluaA==
