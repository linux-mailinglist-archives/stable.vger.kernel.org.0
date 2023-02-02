Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85081688808
	for <lists+stable@lfdr.de>; Thu,  2 Feb 2023 21:10:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231936AbjBBUKT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Feb 2023 15:10:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232514AbjBBUKQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Feb 2023 15:10:16 -0500
Received: from mx0b-00230701.pphosted.com (mx0b-00230701.pphosted.com [148.163.158.9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 944A17CCA3;
        Thu,  2 Feb 2023 12:10:12 -0800 (PST)
Received: from pps.filterd (m0297265.ppops.net [127.0.0.1])
        by mx0a-00230701.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 312IAvdN029469;
        Thu, 2 Feb 2023 12:10:07 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synopsys.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=pfptdkimsnps;
 bh=dfgO/6j/Ul+p5EV8afHtcOD9VwkBykTwS4KwaK3nOAc=;
 b=fhB5pe7pqq66YTesVxJq/RIdsUBhVNFLHFeQkKEw3028Yygy9R1kDkb1+yUzo0Gz16N2
 IrKdV+VRXxWiJqikqqroTFg+WcW0NGzSXLrevsJ8wCSiPPXBNcy0PpY4mLTq6tPaDCmP
 p6Y0bfCaRUrRN2FTWeW57/CCMGl5PLD7TB5uEztINvppGk1IPuqIriLpcZIDJPqBUnbU
 NYUvDLZ5PrbKvxGhz5LwhK0Ai50Vahq5ZOljV2mAfiUWv0HfnMjDkQ0zJbAqOX6rwk56
 hYuB9LuOqMzXHWaSQuA8/fJ57p81GH13LmZo5Zigt1gLUkbrmPCTQOd8cnCbMUqV2ulb 0Q== 
Received: from smtprelay-out1.synopsys.com (smtprelay-out1.synopsys.com [149.117.87.133])
        by mx0a-00230701.pphosted.com (PPS) with ESMTPS id 3nfp8kt4vf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 02 Feb 2023 12:10:07 -0800
Received: from mailhost.synopsys.com (sv1-mailhost1.synopsys.com [10.205.2.131])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client CN "mailhost.synopsys.com", Issuer "SNPSica2" (verified OK))
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 78A2BC0ADB;
        Thu,  2 Feb 2023 20:10:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1675368606; bh=dfgO/6j/Ul+p5EV8afHtcOD9VwkBykTwS4KwaK3nOAc=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=Mr3//66BX02On/JObzwrC+eQJztpJgRazBSllSsIIzE3faZ/c9BQbNNec40cCf+e0
         2uMjZfONuCA8wZ0C8xfqlzyrrC3nmGwDUyatiLkf6K7DON+nKu4hSgrpSclmqEOrKp
         +/xE+eZe01R77XF1ohCauPPhbcbIwLwa4xj2GONsB+M7eToioY50ShaN3xzeis0qTK
         qO+uLjDdvOgUfmSGou8T+G+dYpkND292AOaBwdbPPIiLJfixif0Q4oViK+HRefUTCe
         JcYrQ2B9rQZVp1BbfczJ4dVq86Bgi8ds+9voZE7mjMZ558J4YaYnTQaFQX41MrBzN3
         fGwwnqHL3Bu7Q==
Received: from o365relay-in.synopsys.com (us03-o365relay7.synopsys.com [10.4.161.143])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client CN "o365relay-in.synopsys.com", Issuer "Entrust Certification Authority - L1K" (verified OK))
        by mailhost.synopsys.com (Postfix) with ESMTPS id 248D9A006E;
        Thu,  2 Feb 2023 20:10:06 +0000 (UTC)
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2171.outbound.protection.outlook.com [104.47.57.171])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "mail.protection.outlook.com", Issuer "DigiCert Cloud Services CA-1" (verified OK))
        by o365relay-in.synopsys.com (Postfix) with ESMTPS id AF278A0093;
        Thu,  2 Feb 2023 20:10:04 +0000 (UTC)
Authentication-Results: o365relay-in.synopsys.com; dmarc=pass (p=reject dis=none) header.from=synopsys.com
Authentication-Results: o365relay-in.synopsys.com; spf=pass smtp.mailfrom=thinhn@synopsys.com
Authentication-Results: o365relay-in.synopsys.com;
        dkim=pass (1024-bit key; unprotected) header.d=synopsys.com header.i=@synopsys.com header.b="SaH+ZfGQ";
        dkim-atps=neutral
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T0/n422v4gDtHpU1gFQR2Bg5umOioAYaPBR1vnjZ5GQQ0Q+7EJSKMtSmQNsEwBpb9TaMQnIidXGtOXL0imgky2otsUbgyl6Oj1sou1G4giWOC00CNYzf2P6IT63U28V3ChydJNDYqqow6lS2gAeHpAbGcN8EEGivPby2L91S1GRN5jbXDFOXVVGA9jip31C40O1F/PPdW1WT+4m1lFWtZ396YjJMmfAAyTFjMOP9dMXmBxuqutDKyP5O/8HxiQTybAthl8MyQLN7SfV3kB04w7qIHOGPbmHw/V+qtvUZU9ea/1PXBvo8udHC8HVRoz99BWN07O5WUdNgT8cmAKfxjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dfgO/6j/Ul+p5EV8afHtcOD9VwkBykTwS4KwaK3nOAc=;
 b=lYFGaRXPn+RNlJQ7Y/RA226qv7AoFmA12LzOOEPLLzGBav+u1Sm497XPns+fkDzqmvv2IdWWJcYfXc+Dgf522D8UbBz3RoHP0GwcqSTwcSgHKOojirIdgg4n3AA8rlM6gcrRJo9me7NqUgs8CHldVMPN+FVl2Y3keKJGSZ80fvib+/peAv8e543VhcT7jGaQG07SEWIS7OAe4tNcq4cUQ9bb7nN1FZ6/8ViuZwkAl0Me0Ot6keRDd9kQM7rQL2zk1Ipkzt8s0W1vQljzvE4o7Y+iBl1rYAE9NcUMowTcMdJKN9vhXqT/OxvkiV4aTCK4G6+oEPm8OxbN8KMmvJQfoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synopsys.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dfgO/6j/Ul+p5EV8afHtcOD9VwkBykTwS4KwaK3nOAc=;
 b=SaH+ZfGQz42v5wcnxCGB1juHGwVuY9OiUlHWL2e2+cVLwdeUN+RswqQ5Y4Pizy1LfFaMl01oUm5owdAHirwR5uEMyhf5V09iYO1v3HM89D5jJh6EGGFoRPS6MNDiuyGSUh0UYfJSD4Upjbx47RyzW5/hJ9ERVfjzV143soCoQ8c=
Received: from BYAPR12MB4791.namprd12.prod.outlook.com (2603:10b6:a03:10a::12)
 by PH8PR12MB6866.namprd12.prod.outlook.com (2603:10b6:510:1c9::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.27; Thu, 2 Feb
 2023 20:10:02 +0000
Received: from BYAPR12MB4791.namprd12.prod.outlook.com
 ([fe80::6f3c:bd8e:8461:c28c]) by BYAPR12MB4791.namprd12.prod.outlook.com
 ([fe80::6f3c:bd8e:8461:c28c%7]) with mapi id 15.20.6043.038; Thu, 2 Feb 2023
 20:10:02 +0000
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
Thread-Index: AQHZNetg1e8bWR5O+UmEKJODDDA7p666dI4AgAC0WYCAAO/lAA==
Date:   Thu, 2 Feb 2023 20:10:01 +0000
Message-ID: <20230202200956.kpyp6cq67anpxcie@synopsys.com>
References: <1675221286-23833-1-git-send-email-quic_linyyuan@quicinc.com>
 <20230201190550.jozzrvwdi5lcwtbo@synopsys.com>
 <197a1446-9382-3d83-d26e-694e4d707679@quicinc.com>
In-Reply-To: <197a1446-9382-3d83-d26e-694e4d707679@quicinc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR12MB4791:EE_|PH8PR12MB6866:EE_
x-ms-office365-filtering-correlation-id: 7f8d36d4-a491-4708-1c79-08db05597795
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: oOLVyM1YsNOvr+23s7U5N1jG7FVFuZWGuODm41IBVAsg09ezqmKBzVt/gZ0fUEr67whCdwt8NiHcvZndxMrD+XcWQSaw++Vkat9L8ZG6cysKJDHxEeNyBrdwB6O/9tFDCoES+eLtVL2YyXxQ259B5gCORwLF6Rudg20ZoI6asoz+AHE3SMgELUqO1DpqV28uxz/DokZJhxP6RURJKTKA/GTNxfzn4vqJLJa6+FtrXi9K/0e5r3IysT0OijZLG064ZttlOvgUs+eGTDyqtAVDCMN1mT5eyXohuOZyHHJp30x5J6hN796Mxo/QTrVCEdLVgLYN7TRc2B7AK7roMuDk07pwOC6DZikAeIWpVvKdCZvt7t6DqbbYuOxRHQjrpmaELWkMb34iH+0YkPXRFC4QOHcYx7XdwOlnkrGWu/wlkaWZlrIXaF0YD1DIH3P5lCO8U3mbc2Onq0yIHVcc7WX/I8kiDTtvB14fF1kC5V1q/sD3++jQOJj6/SZMp+68Y1E+79YHBl3Um0WrSXXMCHlphy69IMGjsZ0g6qYZsSHARBd9tMQVn08fSrU5SMRS82+M4YycTV8sksxp0Dh2zbYA49sh3ZTXQcF85iRLyOiDKz73j2552Ka0Nv4moo2rLK1zx/2C5LpOmfoOy75qPZD1WHQ3IzngGLm7Fw1SyczglgW86WqWJMk4iUqwS3MgD98Uj+k3FdYE/5wZZJqQ8njt4g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB4791.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(376002)(366004)(39860400002)(346002)(396003)(451199018)(5660300002)(86362001)(38070700005)(71200400001)(66476007)(64756008)(66556008)(6916009)(66946007)(66446008)(38100700002)(122000001)(15650500001)(2906002)(8936002)(41300700001)(478600001)(6486002)(8676002)(1076003)(6506007)(53546011)(83380400001)(6512007)(26005)(316002)(2616005)(186003)(54906003)(36756003)(4326008)(76116006);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TWcrc2xicjJVWFlpMnNUWDQzVCt3U1pwRHZMVnhlMFg4WStaamtNbVFsd0k1?=
 =?utf-8?B?OVN3TG1JWjFidFhIMFN4ekkvTmJjRnpOTDJ2cWVUNnRGRTY0K280NG9LZ1pB?=
 =?utf-8?B?VUhBejBmWWRtT2ljSk44UDBEdUxRZ2dsaDA4YzF5TzNrelRjR2JZSmdFSlhn?=
 =?utf-8?B?dEVjMmhZM1Z1MjQrenAvUko4R1V3cEJTVCsrMFZodE5YaFQyeDJQc0tWRFRj?=
 =?utf-8?B?UFgxNG5oV09vR0xVT1ZENUFTU3plbXJ6TmVMa2E3eEM3QmJEMmlMdWpqY0Iy?=
 =?utf-8?B?c0RJd2x2VGpEbEtROUgzcFBCMnJIbDVKUHBlaEtIQWowRzRHUGlBM3Rrc2pG?=
 =?utf-8?B?STFCWnRwd21UZEkzY0g1TldmM1RYSkl4YmR0bjVoeldydXlVMlo3aWIvemo5?=
 =?utf-8?B?ZXAyTFYva2RVSmN4eks0K0tRQnkyeERkMDNjbUVPVWtBQXJFbE1PMWo2S0tZ?=
 =?utf-8?B?UVpDTitPZW8wYXVmOHA2K2Z0YXdSU29ZK0lrdDIzQlAxVEVTMCtySWtqNHdQ?=
 =?utf-8?B?MTd0cEROM0dTM2hQZ1VJYkZHNjFVdFdQQlN0ZGlMMG1oSEJaQnVlNzV3YlRV?=
 =?utf-8?B?dzVvR2hwT3hZMktKSnRBb210OFRDdXh5eHNycFVsY0ROOHdSaVRGT0F0azhI?=
 =?utf-8?B?eUpQL2ZTbXpKOW1Yeld5Uit5eE1UcG83RmE2ZEJjN0ZNWjFndklQUHZYMkc3?=
 =?utf-8?B?d2p0R0hFZlAzTTYzYkdBMm1wUXpxNXhaSXR0U3EweWVaRXNDaWdaMUVFWERn?=
 =?utf-8?B?b1lhVzlndHZvTEsrdVh1TDJZaDA3OE0zeFZ2ZklScjM2MlJMN2U0amRway9K?=
 =?utf-8?B?Mk9IYklNbFFaZkNVMFUrL3piZitBUHdmaEpsM2F2bk43ellURnFWTTFtbTNU?=
 =?utf-8?B?R2dOUmJkSzQycCtqUTFhUnJQRGFiY21NS0VOc2xxaE1XMlB5MVJSSzI2cmtp?=
 =?utf-8?B?SDVhNk9YemZ6ZGJuUFBZby93bmNQdU02TXdpWmxKMWRpbG8yR3N6QTRGTEts?=
 =?utf-8?B?NlV1SmVMRGQ5SWhzVjdWdkRTVDlsWXdGSzUyYUFFQ3FjVTgvZDVMU1Y2dEw2?=
 =?utf-8?B?b3lzTXRyZFM4QnBlcUZ3L1VnY0FRaHlSRUNwU2FMMnFYUkUxajhhRHZQeWUx?=
 =?utf-8?B?dWF5WXJEZU5GcmdqdDdYcUZNcTBKSW43NTM3MzBZS0Y0Y3lpRlRvN1c4dThv?=
 =?utf-8?B?cTFoSnZNWkF1V1RmKy96KzFxcGJ1c1VKVm5HeG1CM2dLVWZON1VCdjZ5U0J2?=
 =?utf-8?B?NWZtTWRtaWNoa1Fodm40bzBRdC9hZmtmaUw4TktmeERabmtla09OTEhxZlpM?=
 =?utf-8?B?QVBROE9EN2FYdEhsYnQ2Yjc1WVZocU5HVWZBd0dORCtvQmtWa3pIYUFBK3h4?=
 =?utf-8?B?b1JGSzh5TWZDUVJMLzNya3gzcE5rYi9PMjhWcmIvVkxlS1hDWFhXcVlRK2Ja?=
 =?utf-8?B?NUkwektCYkxUc1JyNG8wU2wwcVkwN1VpcDN3TkFNK0lZTGNzM0JUc2hnNit2?=
 =?utf-8?B?SVAreExEK0Z0dFhTaThBanpBdzJIdG81Sis2b3h0dFVYUGJnSUhySnNRN0I4?=
 =?utf-8?B?NGNtY3VSekdhc2k1d0JCc05HRVkrSCs4d3lzUlRSZ0xyWnJ1VDU0dlFpdmRH?=
 =?utf-8?B?UlFxRkxNTER1MGF5MCs0WmIyTUxYU21TT2xuQ2FPWnl0ZklKWkFLVVVPa0FB?=
 =?utf-8?B?bEljL2l0QTI0UDQvREU1dFpqeHNOc3hSRk5SczFFYXhkY21veEZmZkJlQnVM?=
 =?utf-8?B?L1psOEdZWWVkUDd5dEdrd2VrRkpmZWpaT3JXTnVXUjN1QTNId0lCYko5VFN5?=
 =?utf-8?B?N3hYR0psbUVQMnJncXpUS2gwaUpCR0pXYjRRTmFiSXBYcktvZmIwSTAzN3lv?=
 =?utf-8?B?RjQxSThmalJ3TjNEZzByV084QTB2RVJxRmovdlIrenZyR0hJNUhCaTBUM0RP?=
 =?utf-8?B?RFdZb3E0QUVFWUl3ZjAvQUdNZUljK0NRdmRYdVh1c2hSdWFyY0hSRWNrdUxX?=
 =?utf-8?B?S1lKN3gyaFJUMjFCTDBLc2Q2d01zdEk0OWdvZUdrSFZiV3FGMHhZa25nMFVs?=
 =?utf-8?B?LzFVOCt6SldOYXByeVVWbG8yMWh4cFJqTzQvZlppTTFsVk9lc245d2xVTTFh?=
 =?utf-8?B?UzNrSnlTSXlUa0daS1RmSFhyRlVNSlVUVXZ4R3FiODBtVU9KODdqYjBRR1dO?=
 =?utf-8?B?VHc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9217BA0D09ADC845ADF666A3072548D2@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: FjUC8MkqtRsrns8bgiNvLksdW1czjbxEj1hjrIhiQU3+18oSGnFgv2bcBUC3JDmibYqepOMrukQ9nTuDhM4ZrwS/bFSgHb10h9KdsbxV4UCdsmtmk14OOU7z6GA4S/j1oDfrGcrgmby6GvmWnzJyaILe6t1m44JtyoZaL2xVoWrXLayJO5EkFBFP7zYS12TSAyVQLwsK5b10YYfTyVyfYK2/6794CkhynmhZSemeVZTnvrRzl5zWtjMoSXF7awAbnol2p2/BAoXwE3of4c5+7YOhecPcCi9bxFAQrQcoBqmRu3YJdl6OHiMfea7Nh0N6Tga+/PpS/ac1zLPruyRDLYdjAtZ9uuXl+hIgxUkuyDlVcNGadZJzQIrKzPRsmMcaKdOvn0E4jDRgoKoEUG+hlhqei1jJaPQOJBAOB2UkHim/1yUj80gjwD/xfcgUKMgZA/ZPgPxQmGal/jsr46aB43casJ5DZgTqgJGDTwOLjRhOQLKHXfR8wbJhZCK2Bjk4RDW26M5ao5QeVoFt0/2X0Y/L9nD8I9yaL2XF6pjv8Syg4rG5cCbwYFLnjQJp+YGoF0tO9zzeNveoXFgqTfmrKSA7gu44B9uUgHT7TQOCulVB8zOcnPJhRi6ngktuk1VNMDe6LqnAFGP54SezVMGPg5a0Byjc+OCppkb5dKLm2VjnuhnnLVwM6576rEDxRQ/+XPFz4vWqnGXp+sv4fPHiFOf5Yf+a0kdRCyLV2nNdFtVZdUpeucrf5u53of5K4rCYKZQowzo2VcygJ4lf9jUqXCJuDFUsE3oULClTnPhkSdjqTF/0flHhFYpIMHcLjPtWz0+SxpATP2vrL17zVvpv5Va0V6qdsbcpQKOX7JvSYWWl+SmC2moJ6RiaLRjlCaKT
X-OriginatorOrg: synopsys.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB4791.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f8d36d4-a491-4708-1c79-08db05597795
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Feb 2023 20:10:01.8921
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8rRj/2wDjDtyOYO6FUtg+xT4RzOkMfeEAQZy4ZkL8MLJ2JzwEZnsNCVoaQLQcsQfM5rgVIDefJSfM4NopzMcIw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6866
X-Proofpoint-ORIG-GUID: NDaLpRdssV0jAubLroE91VYrsbhWljY3
X-Proofpoint-GUID: NDaLpRdssV0jAubLroE91VYrsbhWljY3
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-02-02_14,2023-02-02_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_active_cloned_notspam policy=outbound_active_cloned score=0
 bulkscore=0 priorityscore=1501 spamscore=0 clxscore=1015 suspectscore=0
 impostorscore=0 mlxlogscore=414 lowpriorityscore=0 phishscore=0 mlxscore=0
 malwarescore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2212070000 definitions=main-2302020180
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gVGh1LCBGZWIgMDIsIDIwMjMsIExpbnl1IFl1YW4gd3JvdGU6DQo+IA0KPiBPbiAyLzIvMjAy
MyAzOjA1IEFNLCBUaGluaCBOZ3V5ZW4gd3JvdGU6DQo+ID4gT24gV2VkLCBGZWIgMDEsIDIwMjMs
IExpbnl1IFl1YW4gd3JvdGU6DQo+ID4gPiBDb25zaWRlciB0aGVyZSBpcyBpbnRlcnJwdCBzZXF1
ZW5jZXMgYXMgc3VzcGVuZCAoVTMpIC0+IHdha2V1cCAoVTApIC0+DQo+ID4gaW50ZXJydXB0Pw0K
PiANCj4gDQo+IHRoYW5rcywgd2lsbCBjaGFuZ2UgbmV4dCB2ZXJzaW9uLg0KPiANCj4gDQo+ID4g
DQo+ID4gPiBzdXNwZW5kIChVMyksIGFzIHRoZXJlIGlzIG5vIHVwZGF0ZSB0byBsaW5rIHN0YXRl
IGluIHdha2V1cCBpbnRlcnJ1cHQsDQo+ID4gSW5zdGVhZCBvZiAibm8gdXBkYXRlIiwgY2FuIHlv
dSBub3RlIGluIHRoZSBjb21taXQgdGhhdCB0aGUgbGluayBzdGF0ZQ0KPiA+IGNoYW5nZSBldmVu
dCBpcyBub3QgZW5hYmxlZCBmb3IgbW9zdCBkZXZpY2VzLCBzbyB0aGUgZHJpdmVyIGRvZXNuJ3QN
Cj4gPiB1cGRhdGUgaXRzIGxpbmtfc3RhdGUuDQo+IA0KPiANCj4gdGhhbmtzLCB3aWxsIGNoYW5n
ZSBuZXh0IHZlcnNpb24uDQo+IA0KPiANCj4gPiANCj4gPiA+IHRoZSBzZWNvbmQgc3VzcGVuZCBp
bnRlcnJ1cHQgd2lsbCBub3QgcmVwb3J0IHRvIHVwcGVyIGxheWVyLg0KPiA+ID4gDQo+ID4gPiBG
aXggaXQgYnkgdXBkYXRlIGxpbmsgc3RhdGUgaW4gd2FrZXVwIGludGVycnVwdCBoYW5kbGVyLg0K
PiA+ID4gDQo+ID4gPiBDYzogc3RhYmxlQHZnZXIua2VybmVsLm9yZw0KPiA+IENhbiB5b3UgYWRk
IGZpeCB0YWc/DQo+IA0KPiANCj4gc2VlbSB0aGlzIGNoYW5nZSBjYW4gYXBwbHkgdG8gYWxsIGN1
cnJlbnQgc3RhYmxlIGtlcm5lbC4NCg0KRGlkIHdlIGhhdmUgaGFuZGxpbmcgb2Ygc3VzcGVuZC9y
ZXN1bWUgc2luY2UgdGhlIGJlZ2lubmluZz8gSWYgd2UgZGlkLA0KcGxlYXNlIGFkZCBhIGZpeCB0
YWcgdG8gdGhlIGNvbW1pdCB3aGVuIHRoZSBkcml2ZXIgZmlyc3QgYWRkZWQuDQoNClRoYXQgaGVs
cHMgdG8ga25vdyB0aGF0IHRoaXMgaXMgYSBmaXggcGF0Y2guDQoNClRoYW5rcywNClRoaW5oDQoN
Cj4gDQo+IEkgdGhpbmsgQ0Mgc3RhYmxlIGlzIGdvb2QuIGFsc28gaXQgaXMgbm90IGdvb2QgdG8g
ZmluZCBhcHByZWNpYXRlIHRhZy4NCj4g
