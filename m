Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7695E61F7B8
	for <lists+stable@lfdr.de>; Mon,  7 Nov 2022 16:33:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232273AbiKGPdR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Nov 2022 10:33:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231783AbiKGPdP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Nov 2022 10:33:15 -0500
X-Greylist: delayed 62 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 07 Nov 2022 07:33:13 PST
Received: from esa5.hc3370-68.iphmx.com (esa5.hc3370-68.iphmx.com [216.71.155.168])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D3D31F2FE
        for <stable@vger.kernel.org>; Mon,  7 Nov 2022 07:33:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=citrix.com; s=securemail; t=1667835193;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=h3dQD3MWnJPZAt2WaheusOR1dZ+BgzxXlhon7xfaKvY=;
  b=Rb2GDeTYzRucnCxM+mmV+Gdq2K47O8FaPoyQtPYOi1c18NEE4yTBv9Si
   sb5KZtIjqxoq3u5Rrz29TtBETWJQTC/ki2P6fRKal+EtmQYgIcA8mkC3+
   uD8GaJ9fCHWdVBJs9yUBYUmp/mtM5e0Gs2/EdPFsnxrFCfrZfY5ifkmIS
   c=;
X-IronPort-RemoteIP: 104.47.58.104
X-IronPort-MID: 83397301
X-IronPort-Reputation: None
X-IronPort-Listener: OutboundMail
X-IronPort-SenderGroup: RELAY_O365
X-IronPort-MailFlowPolicy: $RELAYED
IronPort-Data: A9a23:nNtSFqPI0SRK0eTvrR0SlsFynXyQoLVcMsEvi/4bfWQNrUor0zxRz
 TQWXT3VO62Damv0L9pwbdm2oElS7ZLUnd5gHgto+SlhQUwRpJueD7x1DKtS0wC6dZSfER09v
 63yTvGacajYm1eF/k/F3oDJ9CU6jufQA+KmU4YoAwgpLSd8UiAtlBl/rOAwh49skLCRDhiE/
 Nj/uKUzAnf8s9JPGj9SuvzrRC9H5qyo4mpB5gNmP5ingXeF/5UrJMNHTU2OByOQrrl8RoaSW
 +vFxbelyWLVlz9F5gSNy+uTnuUiG9Y+DCDW4pZkc/HKbitq/0Te5p0TJvsEAXq7vh3S9zxHJ
 HehgrTrIeshFvWkdO3wyHC0GQkmVUFN0OevzXRSLaV/ZqAJGpfh66wGMa04AWEX0st+OWJcr
 uw8FGAuVSiZuf+O/bW2UMA506zPLOGzVG8ekldJ6GiBSNoDH9XESaiM4sJE1jAtgMwIBezZe
 8cSdTtoalLHfgFLPVAUTpk5mY9EhFGmK2Ee9A3T+PpxujCPpOBy+OGF3N79U9qGX8hK2G2fo
 XrL5T/RCRAGLt2PjzGC9xpAg8efxniqB9lKTdVU8NZKkmWa+UYCByQYTFuSrsikzUqFUOp2f
 hl8Fi0G6PJaGFaQZsH3WBuqoXiFlgQRV9pZD6sx7wTl4q7V5RuJQ2sJVDhMbPQ4u8IsAz8nz
 FmEm5XuHzMHmL6LTFqD+bqO6zC/Iy4YKSkFfyBsZQ0M/9nqpqkwgwjJQ9IlF7S65vXpGTb1y
 ivMqCU4i7wYjt8j3qC3u1vAhlqEvpXVQxQnzgTRUHis4g5waMiifYPAwVre5OpcN4GfZlaGu
 3cAlo6V6+VmJYqAnSqPS80CG7am4/vDOzrZ6XZ0A5Ar8zmF5XGuZ8ZT7St4KUMvNdwLEQIFe
 2fWsAJVoZNWYn2jaPYvZ5rrUpx2i6/9Cd7iS/bYKMJUZYR8fxOG+ycoYlOM22fqkw4nlqRX1
 YqnTPtAxE0yUcxPpAdajc9EuVP37kjSHV/ueK0=
IronPort-HdrOrdr: A9a23:TDoqba/QiBokM+41Zkhuk+F7db1zdoMgy1knxilNoENuH/Bwxv
 rFoB1E73TJYW4qKQodcdDpAtjifZtFnaQFrLX5To3SJjUO31HYYL2KjLGSiQEIfheTygcz79
 YGT0ETMrzN5B1B/L7HCWqDYpkdKbu8gcaVbI7lph8DIz2CKZsQljuRYTzrcHGeMTM2YabRY6
 Dsg/avyQDBRV0nKuCAQlUVVenKoNPG0Lj8ZwQdOhIh4A6SyRu19b/TCXGjr1YjegIK5Y1n3X
 nOkgT/6Knmmeq80AXg22ja6IkTsMf9y+FEGNeHhqEuW3XRY0eTFcdcso+5zXUISdKUmRIXeR
 730lAd1vFImjHsl6eO0F3QMkfboW8TAjTZuCKlaDPY0LDErXQBeoR8bMtiA2XkAwBLhqAC7I
 tbm22erJZZFhXGgWD04MXJTQhjkg6urWMlivN7tQ0XbWIyUs4nkWUkxjIiLL4QWCbhrIw3Gu
 hnC8/RoP5QbFOBdnjc+m1i2salUHg/FgqPBhFqgL3f7xFG2HRii0cIzs0WmXkNsJo7Vplf/u
 zBdqBljqtHQMMaZb90QO0BXcy0AGrQRg+kChPbHX33UKUcf37doZ/+57s4oOmsZZwT1ZM33I
 /MVVtJ3FRCD34Gyff+qaGj3iq9M1lVBw6du/22z6IJyoHUVf7sLTCJTkwono+pv+gfa/erKc
 qOBA==
X-IronPort-AV: E=Sophos;i="5.96,145,1665460800"; 
   d="scan'208";a="83397301"
Received: from mail-dm6nam10lp2104.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.104])
  by ob1.hc3370-68.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 07 Nov 2022 10:32:08 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B/gcbLufji1yIhFzorImL9afOlBvXvAVWFbjFsD9OseW6z7RjvnezfXasIUBa7K1tI9YW+cYHGS7Hkc7MOqyZAG+v1OpsSGk82K7LeFdNcw6wPisDD94XPHEqd0hApvDRvO8mSk+HqJRJU3mx92diO+FpNGGXIOgu8/RYyo3nODfvM0mNB7w27S9PsVsZPo5fltseU4gD7ozh6ybZxa5JLp5UHTStCPUInu4IgCMp6maLHwjRv92JHKeyFIWcvkswXGEr8ayZPZema0RYAv7XtOn3aexw8k/zwzpz39oA+VSaTau5Gc3QwHtjM3uPR32GM6yv27pYJyaw3UcwozjMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h3dQD3MWnJPZAt2WaheusOR1dZ+BgzxXlhon7xfaKvY=;
 b=WKQAqaCX1BLqlknYUmtaXyS5NJY7iaavFnS3J9IkiujwtIf4W21QChg9JMrdLqsohDDeBNcrd+bOOWuQ928QIAoIp9OgRKKGDNQ80Nqs4WefQap3mLcJzbifvNhMPZkOyPRSOPJsI0h6YFOVATQidmO1OdToW+ZFRzOKgE0oCZB5QzjIS10ILlb3kF6lWwI6hvfB2XDuKGsh6ig/lB8rxFD9ADpZiQHKKcPIaVXPSU3r+4MiDXNPzANMXcocC2zQ8Hl6SXX0SoijTBfVDkI4Y7SnDU305Yqpc3DOUpIY4lAjMNParBiEPOOrm7MMQuzzuobWOn4zjGiBWfsLQk0Ueg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=citrix.com; dmarc=pass action=none header.from=citrix.com;
 dkim=pass header.d=citrix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=citrix.onmicrosoft.com; s=selector2-citrix-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h3dQD3MWnJPZAt2WaheusOR1dZ+BgzxXlhon7xfaKvY=;
 b=UXfdj2E9HPfjz43La0A6LBHvdklUTcgKQg62+u7bUmgoUQp9rnJzWI3uXT/ANbDDle5OpAI+YDaJTjEOrU3LOThY9WH/e/+B4wQCfFn7K/BgRNrDQzs+TxeiDlGxpZmd0OIciknQzB9jhwy7ZtWxZF6fMsQ5JV6850qYbPDOJHA=
Received: from BYAPR03MB3623.namprd03.prod.outlook.com (2603:10b6:a02:aa::12)
 by CH0PR03MB5985.namprd03.prod.outlook.com (2603:10b6:610:e0::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.26; Mon, 7 Nov
 2022 15:32:07 +0000
Received: from BYAPR03MB3623.namprd03.prod.outlook.com
 ([fe80::1328:69bd:efac:4d44]) by BYAPR03MB3623.namprd03.prod.outlook.com
 ([fe80::1328:69bd:efac:4d44%3]) with mapi id 15.20.5791.025; Mon, 7 Nov 2022
 15:32:07 +0000
From:   Andrew Cooper <Andrew.Cooper3@citrix.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     "nathan@kernel.org" <nathan@kernel.org>,
        "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "jmattson@google.com" <jmattson@google.com>,
        "seanjc@google.com" <seanjc@google.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Andrew Cooper <Andrew.Cooper3@citrix.com>
Subject: Re: [PATCH 4/8] KVM: SVM: move guest vmsave/vmload to assembly
Thread-Topic: [PATCH 4/8] KVM: SVM: move guest vmsave/vmload to assembly
Thread-Index: AQHY8rjgcXsW5FU0l0OXUo54tNrBNq4zlr0A
Date:   Mon, 7 Nov 2022 15:32:06 +0000
Message-ID: <6c8539fa-38b5-d307-675a-2e272f7a83d3@citrix.com>
References: <20221107145436.276079-1-pbonzini@redhat.com>
 <20221107145436.276079-5-pbonzini@redhat.com>
In-Reply-To: <20221107145436.276079-5-pbonzini@redhat.com>
Accept-Language: en-GB, en-US
Content-Language: en-GB
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.1
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=citrix.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR03MB3623:EE_|CH0PR03MB5985:EE_
x-ms-office365-filtering-correlation-id: 4f1c124d-19bd-4e06-1cb7-08dac0d53a88
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Ap2Hjwx1Rmdw1t8QwSXJibf3UtJhnWIlp1SLBDsFcLU4tp8jNGRknlcQaZyypzc9HtbGFfyWcYDxgu0Q0AQAw7a982yJUVuip+f4CKk1uLvKxaFYOlrlRKLo3PbuOnYP1+Lc0Qaq38q94wYkkChA3dVuXCqojMK+naA0vQt2y486ppAx+WFo3BmUXXc7RBs2OsINy68kqg66BUIgdblAPiJLebBiYfQ44oWoJ8T28OTRCPgitvvvmnV/dIMEcaUBKntBrnh9phTnBDVrU4AF1YuGqhUOx9coyugqnUf9FtcQl/NttJto9q39ZEYguan35ZEa9I+25Eg7hv9l2di1y5EyGJf8CbbnpMp4YIq6j+G2cgXjPNVZPIPZDLkQYTUWDZL0Deo/NEOtnCHNz23p5HZ8X7bMvLG8+yiUWVTYzCp8NHFNsPY4BLdbzS3PZaUpnpz8H6ACzWMnRmjCaRRpAqsRE5xHd3+Fx7S4Z6pBgCmzct+nDZEe5kSQmK+bZRmjYCyMWEff+vMGzAKs5AV5sasJCq0E+iefT87bb/vufFKvX7yRnHtrdcicz8PZPVF3EwOb1tpHnAa2IxLfgfck9rRUoyTqo08HozYobkw8oFYAXaVmAZyr8geCQ/HF+O0kJ13jIHEuiKaaeBQzkQRvX64xN3Y4vDKOhQU0T85GKB+1BXw39rqCce2orjfyTIiouTlX7q244wL2MrqUJVWhxz+1ksraNv/VBjqZZXH6zgmPKQTETi44QO7vmq3N2uHkMSKLHzElkRM2513QNIW/uORkYi96C+zmkJB7TWaFHDoH+QRNaAxCJlfzwy01ZWqnhQZ2tT6y54O/g7UyRSzHMg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR03MB3623.namprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(366004)(346002)(376002)(39860400002)(136003)(451199015)(36756003)(31686004)(86362001)(82960400001)(31696002)(38070700005)(4744005)(2906002)(186003)(6512007)(6506007)(38100700002)(2616005)(107886003)(26005)(53546011)(122000001)(66476007)(66446008)(66556008)(66946007)(64756008)(478600001)(316002)(54906003)(8676002)(110136005)(8936002)(91956017)(4326008)(76116006)(6486002)(71200400001)(5660300002)(41300700001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZWFJNGErQjErUHI3dkYvZTZNZnNYZ3V5dHFMVTlxNEo4a1RSNGwxb050aldq?=
 =?utf-8?B?Wlo1a0I5YWZCOWoyRklEaEw2dURzeFBPV0QwVHNDRWg4dHkyR2NDMzkzcnkv?=
 =?utf-8?B?V285L3VmS1RPYWZkNk51TkhQQUJ1UG1TeDVCWWtpcXJ2N25WcWVIdWV4MkJI?=
 =?utf-8?B?R1BkbVhzdXdnbEV0ZXF2M3haMG9rWGwrZytOcUxRQ0dFVC9yRVNlY0JZSEs1?=
 =?utf-8?B?UUY4RnYvUks0aW1BdXlHRTA2S2NsV1Y2WXE4Nnd5UFB6dnVKcytzWkQ2bi94?=
 =?utf-8?B?Z2NSQ2REQW1QTndGSktEcW9MNW05Y0dUMnVwVXg1VTYwZGc5OUdHQmhjUkRk?=
 =?utf-8?B?VktjaTBNa0drRndmYUhzcTlWNUR3SUYvYkVmUjhzTUdMaVdxOTQ3a3FDREQw?=
 =?utf-8?B?UGNFK1AzdEhqdjNoZW1yVHM2YWV3VDhLMkp3ekZaaDMrbzlhalEzTEhnQkpo?=
 =?utf-8?B?S2VOcGJlTm0vUkZ0L3pTTTVxTkxVdG5YaEdLSmJWLzdqZ0tLM2JiM2l2VGFC?=
 =?utf-8?B?WU5XRW5Hb3dNbVlXZDQydk80L0dvVmoydVpFU3llNzhCc1NPRWdEdEpubFZC?=
 =?utf-8?B?bmdoV2xxbVhVRERaQWpTK1EzWlhnb1MrZkxmNlFLTWtnSklsK0l0Uzh4VkFx?=
 =?utf-8?B?T1BmN0kxMFdWeFZFYXp5V0FiNGh0cS9CRjFwQUFFeVBrWnlyTXRLZ3NSaU8r?=
 =?utf-8?B?Yjd0R0dqRUVxZmFoRG9hYjljOFFZUVhxK0tReGNvWkFCcHlnV3FCUEx5eWNQ?=
 =?utf-8?B?RHNrMHVraGt2V01SOTVSUjA4ZTlGeXM0V25vRzU4cWNjLzgzOFFUNEJKSUZT?=
 =?utf-8?B?b1ZKdklMRjY1K2xmU0MyWjcvanBveVplcWpha0JaS1FGdjJoRDVBeFVlN3Jy?=
 =?utf-8?B?UUVkdnZ2MkFtNC9FeHVYVjdnZGtSUjlBcm1PZVpVbkNadEZSWjVNUXRjeVo4?=
 =?utf-8?B?M0dEVndqdFRGeWZQWWEzV3VmV3Y5YmU5Q1FwUjFGN3diYW10czFCWEFMajZF?=
 =?utf-8?B?aU1pbFAxeUF2NGROTjZpUVNCbk1lZU9SdGRsSHkrMnJrTUo2VWVKb2NORmRn?=
 =?utf-8?B?R3hGMGZBbUlaZ0wwWGNnQWpnZkhLT1gzdG9OT1V3d2RMNFh0dllpNFNJaEt4?=
 =?utf-8?B?bHhTWC82SG1DWkFGYWIxOG0wbVJwd3YrUWdFeGNrWlBTeGhDS0w0K1ovS0Rz?=
 =?utf-8?B?N3pGNDQrRWNYR1lVNGRBYmFXY25KNG9mS3IvSURYUzF4eXYxRU5TNVZrWkJy?=
 =?utf-8?B?eEFkNU5QUitQZ0Fhczl6NlZLalFrTWNUcW9lWEE5WGdhMzVOblpubXB1UnZ3?=
 =?utf-8?B?WFNOOGJaY2x1d0tsRkoxenNqM2o5MS9TSVJONWxHTDVGTk9MWlpFbUJ2dkhi?=
 =?utf-8?B?RDdzbVRJVmlaZVJkUHB1U1hFc3lHeXIybXpZWUJ5eUNTc0JkY2FrUENiZVl6?=
 =?utf-8?B?VTJMS1hmT0s1WDcwZExoYVFOMXRIMWZtcEJzTTdlcDdiSVVNRm85SHJFVkNP?=
 =?utf-8?B?K3RkRnROcDJrbDlMWU00eExvSm1ZVGhZRlJrN0RldGJPT0kvdkpjSmM0am1v?=
 =?utf-8?B?RmlYTGcwNXEzR0puNmF5bEpFb2I2V0JDNHdQOFk1UGJQRnVYTTZrQkNWUkFp?=
 =?utf-8?B?V1g3blRHY2tLeXJIcHAwVHVpcUJzMUNHNVpPdElpMUd4MkpBRVovWDhIM1BP?=
 =?utf-8?B?bHdZRG1UdFk1OXE0b3ROeEEwdktISmJoMktuNmo5YlZCZ2JNTEhEUHAwTmxx?=
 =?utf-8?B?dlh3cFh6Q1RQRDNNaHcrQkp0MFA3WnVMVkl6WCtrbHVyRU1iMmZTaEhzRTBZ?=
 =?utf-8?B?a2lHMFpQU1M1c09SM1JxS1BKeWpvYmpRMG53d2pUL2xTbFYySGdEWVNrclly?=
 =?utf-8?B?QkVjRTNYZzBrYmVKeks1cUFoU0IzNU5xSUg2YlNMcEd2QWg0TXFQcm5RVGRq?=
 =?utf-8?B?M09qTTBqU083dHM3bSszdTA3R0l2eldrR2g3SXp0RVNIeVpURVB0M1U4TEVL?=
 =?utf-8?B?ZHRGQUk5bVRhZ3llRlRZZlByWEJKTGlhZ3NlSnh3V2RRSi9zTm9aQ2E5SmhU?=
 =?utf-8?B?YTRQaTVsWTZtUjZnRHdNbnBvcVBlVVlCaTVrdnRvRVY0ck9oUEIwUUt5OEtO?=
 =?utf-8?Q?B+PZ5h0s55D8Npgf4hkV1Pj0U?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <53E79B78F8B2AC4DAE2E282E7541A0BE@namprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: citrix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR03MB3623.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f1c124d-19bd-4e06-1cb7-08dac0d53a88
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Nov 2022 15:32:06.8599
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 335836de-42ef-43a2-b145-348c2ee9ca5b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hJQUE3UMJEXu+RIvIraSqi32wWxsFHPRj1TbD3yDiVNluqPEcIRy9H0mG1RGMFDwRe5/faTW0GZiE6qtD8LqSE4ukpFg83gKdZ3uxD7JOaI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR03MB5985
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gMDcvMTEvMjAyMiAxNDo1NCwgUGFvbG8gQm9uemluaSB3cm90ZToNCj4gZGlmZiAtLWdpdCBh
L2FyY2gveDg2L2t2bS9zdm0vc3ZtLmMgYi9hcmNoL3g4Ni9rdm0vc3ZtL3N2bS5jDQo+IGluZGV4
IDRjZmE2MmU2NmEwZS4uYWU2NWNkY2FiNjYwIDEwMDY0NA0KPiAtLS0gYS9hcmNoL3g4Ni9rdm0v
c3ZtL3N2bS5jDQo+ICsrKyBiL2FyY2gveDg2L2t2bS9zdm0vc3ZtLmMNCj4gQEAgLTM5MjQsMTYg
KzM5MjQsNyBAQCBzdGF0aWMgbm9pbnN0ciB2b2lkIHN2bV92Y3B1X2VudGVyX2V4aXQoc3RydWN0
IGt2bV92Y3B1ICp2Y3B1KQ0KPiAgCX0gZWxzZSB7DQo+ICAJCXN0cnVjdCBzdm1fY3B1X2RhdGEg
KnNkID0gcGVyX2NwdShzdm1fZGF0YSwgdmNwdS0+Y3B1KTsNCj4gIA0KPiAtCQkvKg0KPiAtCQkg
KiBVc2UgYSBzaW5nbGUgdm1jYiAodm1jYjAxIGJlY2F1c2UgaXQncyBhbHdheXMgdmFsaWQpIGZv
cg0KPiAtCQkgKiBjb250ZXh0IHN3aXRjaGluZyBndWVzdCBzdGF0ZSB2aWEgVk1MT0FEL1ZNU0FW
RSwgdGhhdCB3YXkNCj4gLQkJICogdGhlIHN0YXRlIGRvZXNuJ3QgbmVlZCB0byBiZSBjb3BpZWQg
YmV0d2VlbiB2bWNiMDEgYW5kDQo+IC0JCSAqIHZtY2IwMiB3aGVuIHN3aXRjaGluZyB2bWNicyBm
b3IgbmVzdGVkIHZpcnR1YWxpemF0aW9uLg0KPiAtCQkgKi8NCj4gLQkJdm1sb2FkKHN2bS0+dm1j
YjAxLnBhKTsNCj4gIAkJX19zdm1fdmNwdV9ydW4odm1jYl9wYSwgc3ZtKTsNCj4gLQkJdm1zYXZl
KHN2bS0+dm1jYjAxLnBhKTsNCj4gLQ0KPiAgCQl2bWxvYWQoX19zbWVfcGFnZV9wYShzZC0+c2F2
ZV9hcmVhKSk7DQoNCiVncyBpcyBzdGlsbCB0aGUgZ3Vlc3RzIHVudGlsIHRoaXMgdm1sb2FkIGhh
cyBjb21wbGV0ZWQuwqAgSXQgbmVlZHMgdG8NCm1vdmUgZG93biBpbnRvIGFzbSB0b28uDQoNCn5B
bmRyZXcNCg==
