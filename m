Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E9F560344B
	for <lists+stable@lfdr.de>; Tue, 18 Oct 2022 22:49:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229885AbiJRUtm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Oct 2022 16:49:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229933AbiJRUtj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Oct 2022 16:49:39 -0400
Received: from mail1.bemta35.messagelabs.com (mail1.bemta35.messagelabs.com [67.219.250.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E97F14D00;
        Tue, 18 Oct 2022 13:49:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=motorola.com;
        s=Selector; t=1666126173; i=@motorola.com;
        bh=+3z6C3qmTlrJuuz/m7503j3OQ8Y9RC5LWpivMd8ZF/w=;
        h=From:To:CC:Subject:Date:Message-ID:Content-Type:
         Content-Transfer-Encoding:MIME-Version;
        b=syTJG+e2N+n+YsYtfLuYCZe8n66wcB2g6QITJ+LaGTa2fN+YTlahDkLpAvjdeCNwQ
         0lobHrCzBhWDuXKoqehP8kSpDkNYPv6xZd3Jnp1oVa3PbWIm7VMoIncna+bZRRkNeZ
         hY9Y22CPkNNguGDo0z38xfpcmBADS2l8bVlSSokX3N1Gb62LTApBu8x02fnC5XYH3+
         0h4lCP+NZDfSkpwv+RpneN85LMkv1dpf0F8F5XkXnEEzsuzpoP3ZpCMCGrTgaR+y5P
         Za46Qeavy780M0hYFgtvTxzN+f9hcl16KRovG2OxBjUtwSjN+P9b+2p/4lrORd+vt5
         Sh8VB3bWkwqcQ==
X-Brightmail-Tracker: H4sIAAAAAAAAA1WTe0xbZRjG+/Wcnh5IzzgUkE8CzHTZ4kpaLrv
  kIBnMxGRdHAMjy3RzaClH2tkL6Slb4Q/FqIy1wsa4DUa538JYlMrmpWytwERmJsuoghcMQtEx
  MhEHg00snvawif+8eb7ze973e97kOzgirhJG4LTZRBv1Sq0EC0TVsfo42dHgNFWcuyuW+qrII
  6Q8rlOAKmnvw6j3Wj7CqNNlrUKqqagVpUa/qMOo5vYPEKq3yM2nVlZLEaqxZwpQXY0u4V6R4k
  JxjUBh7zqNKZy2bqGipbRcoDjzT5yi13kfKO7bo9OFRwQafZbB/IZA3TG+JsgtTjGfG44uBKs
  7LSAQB2QbAksbvgYWEMAemgVw3vkaB64AOOR2C31ATNr4sPMPsw+IyQkAS3/z+gFGyuBQX6O/
  O5RMgnUVnUKfCSGvCeDFR3f4PhBCZkNXdSNmAThrouH0qJTzy2H9w4f+XpTcCm2LNr+FII9B7
  1g+F+gpuHyj2z8FIcPhj54Gv4YkCVv7RhBOh8HZaa/ApwlSBOtarOvLnICDfZOA80TB2w3WdZ
  0CZzwNwHcVJFPhPXso9zkadpX8inJ6M6xqnhdyOhJOjn+K+baC5CoGp/6yAO6wjML66csY54q
  D9Q8G112/k/DOz3OASy2H45UVGKdjYHvTHMIlDYbDNR70LJDWbliudkNL7YaW2g0tjQDtArsZ
  2niCNsri4+VZRk2O2qRTarRyZYFMKc9jZCdpxiRLkCtPMnKaYeRMvk6lzZbraZMdsM8v25j98
  mdgtX1V3g+exvmSMKLuwUGVeFOWITtfrWTUrxvztDTTDyJxXAKJ8jWWBRvpHNr8pkbLPuLHGO
  IiSSgRuilNJSaYXKWO0eRw6AZ4CXdfuXoVwUc+d7LV+b2brZUXvE4E7/DXmqUiF4Lbr1lciBj
  VG/R0RDgxFsQOIn2D1Hn6J9c8/l1ug6iIEALweDyxKJc26jSm//O7IBwHkhAiMYCdItLoTU/S
  3GWD8tmgu3oP+oKalP+hiEJ+c96l2D/nk2qSTwW9bYgv3zHyzgDvBXdGj2MmrKobnr9l2LfiW
  bsZcxFPexGk6q5Pv1rgaLOHHx2bFy5EfrhSdWDnlPVm0P6UpMxz31bvfmtx1CZLs862jm3OSj
  9TeOvQkcEq29KWmfTEAVW3w2RGPHtsjhK+AFQWDC9lfvNTYMBkoJnnGFYl7BkLSBiQfrJms2c
  sTCdbF/eJdBPbq70HbJ052zNSd1V6Cctx6btNbSHLzy6k7P8Ov/yM4eMvMU+FpCxZ/74b3VYW
  W79176VfPI+GoiZ+sM/OOe5tIzO1wT0agTes6RXnDtJOmBjr8Y5O8dm/E5+P6T/8XErxefTYd
  USCMmplvBQxMsp/AST9RBKpBAAA
X-Env-Sender: jvanhoof@motorola.com
X-Msg-Ref: server-19.tower-655.messagelabs.com!1666126170!230906!1
X-Originating-IP: [104.47.110.48]
X-SYMC-ESS-Client-Auth: mailfrom-relay-check=pass
X-StarScan-Received: 
X-StarScan-Version: 9.87.3; banners=-,-,-
X-VirusChecked: Checked
Received: (qmail 15341 invoked from network); 18 Oct 2022 20:49:31 -0000
Received: from mail-tyzapc01lp2048.outbound.protection.outlook.com (HELO APC01-TYZ-obe.outbound.protection.outlook.com) (104.47.110.48)
  by server-19.tower-655.messagelabs.com with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP; 18 Oct 2022 20:49:31 -0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WBltO7uzfNCUUAX/GpSlodhoRnip7rfeXXB5ODSugVZHS2v2XvImYiZVMcXqs4D8TBpB9KFjkFGUJ6EC0N2ceJTDEs5qGpvSpuBMYPFARQXVZWGLlzOPA5Pf+KjvtDAkGM2aw83RG61RF7y5b0oKCkaQcN+KA50EuK7djCMAOpdEA/+P4LmIdxV/CGBiUn9tob4tLPaJgyn0M0agzN+THcK5VQqoA+TICuIfyricJx8ypl2E5XM3qMroV7ic97rzkh/9I99sX6ouTKbmp/s/N8POPn1GvBJeeuACswj8zcxmNP3uKD4j0vwQ4PJivhJgcpOu0PT5F0a4ujLJgeYv/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+3z6C3qmTlrJuuz/m7503j3OQ8Y9RC5LWpivMd8ZF/w=;
 b=aZaqjSfq8W3CnAzSvkUegz/mg7fkYS8FNJIDQZjewokBpb0ApDmUHxNGPbrg5Ih3R1Y3UAXrxzZktE4ACgJQhnZ+XBQqxktxiaKMggB/4NzLm+tKubLw3P7N6r17yghWLlDH1QDlDGpmjMbmzVnv99sJ1y4UxIaYMMJIFzObTg3yS23FoNcBwCnyfnN/b0iobgwjWVLsRXeimg8zJK23CEtNx/trpVUPc4SBQWal4W99dcyTTZUY5G24lU1GPh1rgYSSkqa/MlTpsrHwdWV3BouK7Bwa5tTRi7pkKp4UanB9bkeCSSSCmusXvjLH0eN5B9QyA33DCGdyEHyu1OALVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=motorola.com; dmarc=pass action=none header.from=motorola.com;
 dkim=pass header.d=motorola.com; arc=none
Received: from PUZPR03MB6131.apcprd03.prod.outlook.com (2603:1096:301:ba::8)
 by TYZPR03MB5248.apcprd03.prod.outlook.com (2603:1096:400:3e::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.8; Tue, 18 Oct
 2022 20:49:28 +0000
Received: from PUZPR03MB6131.apcprd03.prod.outlook.com
 ([fe80::c88e:b6dd:28e:523d]) by PUZPR03MB6131.apcprd03.prod.outlook.com
 ([fe80::c88e:b6dd:28e:523d%4]) with mapi id 15.20.5746.017; Tue, 18 Oct 2022
 20:49:28 +0000
From:   Jeffrey Vanhoof <jvanhoof@motorola.com>
To:     "thinh.nguyen@synopsys.com" <thinh.nguyen@synopsys.com>
CC:     "balbi@kernel.org" <balbi@kernel.org>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "dan.scally@ideasonboard.com" <dan.scally@ideasonboard.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "laurent.pinchart@ideasonboard.com" 
        <laurent.pinchart@ideasonboard.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "m.grzeschik@pengutronix.de" <m.grzeschik@pengutronix.de>,
        "paul.elder@ideasonboard.com" <paul.elder@ideasonboard.com>,
        Jeffrey Vanhoof <jvanhoof@motorola.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Dan Vacura <W36195@motorola.com>
Subject: Re: [PATCH v3 2/6] usb: dwc3: gadget: cancel requests instead of
 release after missed isoc
Thread-Topic: [PATCH v3 2/6] usb: dwc3: gadget: cancel requests instead of
 release after missed isoc
Thread-Index: AQHY4zLbXRUpqdOqTUOotJbe2PZC1A==
Date:   Tue, 18 Oct 2022 20:49:28 +0000
Message-ID: <PUZPR03MB613101A170B0034F55401121A1289@PUZPR03MB6131.apcprd03.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PUZPR03MB6131:EE_|TYZPR03MB5248:EE_
x-ms-office365-filtering-correlation-id: 319d706e-ad23-493c-d5cb-08dab14a3ff8
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zvXU5O5itWmKx4uJKAF9tLlGFZjzTA7rk1VGPuTvdnrjX+1CQiy1i1rHlYVh/diWDd0ddg7B8U1vh1hy09GLSvOmHVJqwGkQf7RrBkDV7bgWgmm/8ZZWnqRUMoLje4DpF4WRtHcQAo2TP23DuUrIlLoj8BUX43YrROvvY/U8XOUJreLvHiWHMWF4Otkp80BBBbgCa8RjaLnNniGQuaXDCmYZyokmR/LtavSTBk7/03jmYfqVjuI37XnT8lZm2mUZdtIvIdRVMAsADFbUYxgJMo/mZCZkQCBf3VY+Otr4WQetrUrif8TSngRcc8GdIsWZ2FtcUaC9o6Xo+s0HwBcPf8iucMK4Y1ZygwY80X/pP9EeTCZYxcguX5ZLR+Nl4HjmGuH6rU8OfI2LlM6WzsEPQjAHztuMRCUVvnUJC5OsH0oQ9SFo/Wy4xBu2itolzACT+gzRFrAqV1w24sk3FTzMM5LMlTTcmwZIHtBah7366Fm9JBhavFkFy3T2tcfQGCLVet7y7tegfvCJZSds45lE8Yw4N8KBU7JrzL0qgUGqxObIaoYL9iuesVnqdftPoOxePDqhXGah4sYvrcLdx364x9FBK2l9Wsz0OZ1U1lH8iHoGQIzKLpPbEuN7nQLPsv5mAzgPDaOKSJ5YJ7IzQaxOmuTDDew+Tr2MwKG4Txpr0qz8xa/Y7GXmoq0oSOY+a8kC98j4akP7kNKA/DLqD5o5MFrNSUeVwNPwkTtAwti4LKG8qZ3jJ0jfDcaVZOUEACT/AP8tc1KaptIDShGSleuCT/4+S5vaERquuDI81uwNeXKy+Xn++PAHmScTjlfDTJO3M+dGffrrtVPDaUMLdH5JKA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PUZPR03MB6131.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(136003)(376002)(366004)(396003)(346002)(84040400005)(451199015)(76116006)(38070700005)(86362001)(33656002)(26005)(41300700001)(64756008)(82960400001)(4326008)(53546011)(7696005)(6506007)(66446008)(8676002)(52536014)(5660300002)(55016003)(66556008)(9686003)(8936002)(66946007)(91956017)(966005)(107886003)(71200400001)(7416002)(478600001)(6916009)(54906003)(316002)(66476007)(38100700002)(122000001)(83380400001)(186003)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?YWZL6GHsG7/c4bZC77/o5MvMND54lS+P4/Qfk+0gMUbuf4t+Co78ul2Dbb?=
 =?iso-8859-1?Q?9HUIcbIVZ3G6iEkeBU6Q7MqbDzNTjphvnFvu/HRJC2mfSrEALS7z+Y0J48?=
 =?iso-8859-1?Q?lNgF/oISizCGiItLU/UrlWgHPLfvvfMZ/ayaaR1XG1uzZsyfT6vptaGZRf?=
 =?iso-8859-1?Q?RqIMiIcKbx7JFrWqglzQH7JO2KZsOjfvxI53XFMEKutJFnv8Fr/rzsmO78?=
 =?iso-8859-1?Q?wPvyQ4NSXnpTEs7q8BTSowr9PUBmvUL/16B1bJKp6A1xgPpJDOA3LC/uma?=
 =?iso-8859-1?Q?eaDBCQXUTTsb9qvTiPGqWLo7mtg/tP83VdW46ec4dsQSLUxie+5gOPKK6h?=
 =?iso-8859-1?Q?0Kni775Be8nQCEWjJEXumw1hjhi0xlpQm7ogHpD56RdzMQSpvyG3LyU2gg?=
 =?iso-8859-1?Q?jReHa+3c2Dp2FM3USMpcJzl15wS7gfd7eOgJAwa9/fc822rvgWqzZSp5AS?=
 =?iso-8859-1?Q?hdhb9sonKBRbxaimvWnm2iPmIoTkYFST+a7u/8VQCEYVMLkMEKRi5ZhUfd?=
 =?iso-8859-1?Q?W2lOCxk4e1mfAnTy7Xf7s3fWsY/Y3MnhWSt8mTX0KQ9i0JEHS1HA1PGjBO?=
 =?iso-8859-1?Q?yb/b7jfJLBlXVa5PM3vfBab03A73dJf9oCgaIr0HfCcYJwS5SRjuBR/iVe?=
 =?iso-8859-1?Q?J7NEfKwQDcq76R3d7DneLUzGn3CrE51rBw1Wmp4i7EnaAmoBBd65zWTZ3q?=
 =?iso-8859-1?Q?2ut0ilGuXWJapFQ2HQlClnmySLjG6WPzYCP1gtlYrsV96uVBfbX8/L817Z?=
 =?iso-8859-1?Q?J5ajfZkIAPcvWapTk5DFT6ueqON1YHjvBWxoXg6DfDqp2W+vbdZp60AbEO?=
 =?iso-8859-1?Q?isH1VueKkgW00JPNVjo8hn+KFZI1/5Pui469hrt6tXQs8X0Kl6ljmipHvp?=
 =?iso-8859-1?Q?ZMKGmbuG3dC1Jeqbm+BQDy5HgKVhH8zB9i2y9YwTjXi+r3K34QU5Xfn8me?=
 =?iso-8859-1?Q?FHtO2TY8x70YXjSA02E3fsCrgogi8vprUjUgIVmx79cPyURbBltYmTlFO2?=
 =?iso-8859-1?Q?rJIctk7U+ET+dWQQvV+2PCgm3VOlTH6IM8BVaij9GYP3GvtBSTn545dbbI?=
 =?iso-8859-1?Q?SL3gi9Cjv+5vOguIEVLtsS9o7+0R4FB5FXsUbTSo6fO6AaAT2kGqm0yit7?=
 =?iso-8859-1?Q?PEI6fpzNTiiAkypZj1Ya7BUVeLKni8f/Ib8nE1g4WXpFL2Fl2RW6VCQypd?=
 =?iso-8859-1?Q?J/q4HcqI0ZwCfh5XWRlf0o03F44OEfi7nowjAyRWN3Mo8581GqG71yhO3x?=
 =?iso-8859-1?Q?/uiCmWR/thapE8cVKIvPIiehPZg57fvSYaORA1yAE2/j9hO7XtEX8WrXLQ?=
 =?iso-8859-1?Q?r6XrEx+OJMzTNjFGD4dTEqCBs2UgeQ3ovTAfAcZN1OprMFAz7R85c20Z8t?=
 =?iso-8859-1?Q?/rNUmrRvRSd/pSP9XOJdkjUTyFcqvxyef0ihaiP6FDUHdx5qB2rFOs3YYh?=
 =?iso-8859-1?Q?hY9ryld9SHs8Rmv5pYfy1SLhjOaivveryY4CaT6D/yr+pu9vOzBuIcc5y5?=
 =?iso-8859-1?Q?OP2u7qHlFAdEbiaU0ZrOKNk4QH6uzct2I3ojf6BytSdXfRy3tFKGx7w9ov?=
 =?iso-8859-1?Q?Wz6NI3ydHWxgujRm2P693LKuaKATfGY/pL7gbZL0Q8sFVJFXvlw0V26tL1?=
 =?iso-8859-1?Q?2RRFosXLYuTwE=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: motorola.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PUZPR03MB6131.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 319d706e-ad23-493c-d5cb-08dab14a3ff8
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Oct 2022 20:49:28.5001
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5c7d0b28-bdf8-410c-aa93-4df372b16203
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: h9ts9s1D1PwGMlKew+6xn3fHHmqaXJHabw6pr8vDb7Sko1x9bzVgV4mV3+ue8phKP0Ylt/Vx43pF/I/WOthU6Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYZPR03MB5248
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From qjv001@qjv001-XeonWs Tue Oct 18 15:37:29 2022=0A=
From: qjv001 <qjv001@qjv001-XeonWs>=0A=
To: Thinh Nguyen <Thinh.Nguyen@synopsys.com>=0A=
Subject: Re: [PATCH v3 2/6] usb: dwc3: gadget: cancel requests instead of=
=0A=
 release after missed isoc=0A=
References: <20221017205446.523796-1-w36195@motorola.com>=0A=
 <20221017205446.523796-3-w36195@motorola.com>=0A=
 <20221017213031.tqb575hdzli7jlbh@synopsys.com>=0A=
 <Y04K/HoUigF5FYBA@p1g3>=0A=
 <20221018184535.3g3sm35picdeuajs@synopsys.com>=0A=
MIME-Version: 1.0=0A=
Content-Type: text/plain; charset=3Dus-ascii=0A=
Content-Disposition: inline=0A=
In-Reply-To: <20221018184535.3g3sm35picdeuajs@synopsys.com>=0A=
X-Mutt-References: <20221018184535.3g3sm35picdeuajs@synopsys.com>=0A=
X-Mutt-Fcc: ~/sent=0A=
Status: RO=0A=
Date: Tue, 18 Oct 2022 15:37:29 -0500=0A=
Content-Length: 5434=0A=
Lines: 124=0A=
=0A=
Hi Thinh,=0A=
=0A=
On Tue, Oct 18, 2022 at 06:45:40PM +0000, Thinh Nguyen wrote:=0A=
> Hi Dan,=0A=
> =0A=
> On Mon, Oct 17, 2022, Dan Vacura wrote:=0A=
> > Hi Thinh,=0A=
> > =0A=
> > On Mon, Oct 17, 2022 at 09:30:38PM +0000, Thinh Nguyen wrote:=0A=
> > > On Mon, Oct 17, 2022, Dan Vacura wrote:=0A=
> > > > From: Jeff Vanhoof <qjv001@motorola.com>=0A=
> > > > =0A=
> > > > arm-smmu related crashes seen after a Missed ISOC interrupt when=0A=
> > > > no_interrupt=3D1 is used. This can happen if the hardware is still =
using=0A=
> > > > the data associated with a TRB after the usb_request's ->complete c=
all=0A=
> > > > has been made.  Instead of immediately releasing a request when a M=
issed=0A=
> > > > ISOC interrupt has occurred, this change will add logic to cancel t=
he=0A=
> > > > request instead where it will eventually be released when the=0A=
> > > > END_TRANSFER command has completed. This logic is similar to some o=
f the=0A=
> > > > cleanup done in dwc3_gadget_ep_dequeue.=0A=
> > > =0A=
> > > This doesn't sound right. How did you determine that the hardware is=
=0A=
> > > still using the data associated with the TRB? Did you check the TRB's=
=0A=
> > > HWO bit?=0A=
> > =0A=
> > The problem we're seeing was mentioned in the summary of this patch=0A=
> > series, issue #1. Basically, with the following patch=0A=
> > https://urldefense.com/v3/__https://patchwork.kernel.org/project/linux-=
usb/patch/20210628155311.16762-6-m.grzeschik@pengutronix.de/__;!!A4F2R9G_pg=
!aSNZ-IjMcPgL47A4NR5qp9qhVlP91UGTuCxej5NRTv8-FmTrMkKK7CjNToQQVEgtpqbKzLU2HX=
ET9O226AEN$  =0A=
> > integrated a smmu panic is occurring on our Android device with the 5.1=
5=0A=
> > kernel which is:=0A=
> > =0A=
> >     <3>[  718.314900][  T803] arm-smmu 15000000.apps-smmu: Unhandled ar=
m-smmu context fault from a600000.dwc3!=0A=
> > =0A=
> > The uvc gadget driver appears to be the first (and only) gadget that=0A=
> > uses the no_interrupt=3D1 logic, so this seems to be a new condition fo=
r=0A=
> > the dwc3 driver. In our configuration, we have up to 64 requests and th=
e=0A=
> > no_interrupt=3D1 for up to 15 requests. The list size of dep->started_l=
ist=0A=
> > would get up to that amount when looping through to cleanup the=0A=
> > completed requests. From testing and debugging the smmu panic occurs=0A=
> > when a -EXDEV status shows up and right after=0A=
> > dwc3_gadget_ep_cleanup_completed_request() was visited. The conclusion=
=0A=
> > we had was the requests were getting returned to the gadget too early.=
=0A=
> =0A=
> As I mentioned, if the status is updated to missed isoc, that means that=
=0A=
> the controller returned ownership of the TRB to the driver. At least for=
=0A=
> the particular request with -EXDEV, its TRBs are completed. I'm not=0A=
> clear on your conclusion.=0A=
> =0A=
> Do we know where did the crash occur? Is it from dwc3 driver or from uvc=
=0A=
> driver, and at what line? It'd great if we can see the driver log.=0A=
>=0A=
=0A=
To interject, what should happen in dwc3_gadget_ep_reclaim_completed_trb if=
 the=0A=
IOC bit is not set (but the IMI bit is) and -EXDEV status is passed into it=
?=0A=
If the function returns 0, another attempt to reclaim may occur. If this=0A=
happens and the next request did have the HWO bit set, the function would=
=0A=
return 1 but dwc3_gadget_ep_cleanup_completed_request would still call=0A=
dwc3_gadget_giveback.=0A=
=0A=
As a test (without this patch), I added a check to see if HWO bit was set i=
n=0A=
dwc3_gadget_ep_cleanup_completed_requests(). If the usecase was ISOC and th=
e=0A=
HWO bit was set I avoided calling dwc3_gadget_ep_cleanup_completed_request(=
).=0A=
This seemed to also avoid the iommu related crash being seen.=0A=
=0A=
Is there an issue in this area that needs to be corrected instead? Not havi=
ng=0A=
interrupts set for each request may be causing some new issues to be uncove=
red.=0A=
=0A=
As far as the crash seen without this patch, no good stacktrace is given. L=
ine=0A=
provided for crash varied a bit, but tended to appear towards the end of=0A=
dwc3_stop_active_transfer() or dwc3_gadget_endpoint_trbs_complete().=0A=
=0A=
Since dwc3_gadget_endpoint_trbs_complete() can be called from multiple=0A=
locations, I duplicated the function to help identify which path it was lik=
ely=0A=
being called from. At the time of the crashes seen,=0A=
dwc3_gadget_endpoint_transfer_in_progress() appeared to be the caller.=0A=
=0A=
dwc3_gadget_endpoint_transfer_in_progress()=0A=
->dwc3_gadget_endpoint_trbs_complete() (crashed towards end of here)=0A=
->dwc3_stop_active_transfer() (sometimes crashed towards end of here)=0A=
=0A=
I hope this clarifies things a bit.=0A=
 =0A=
> > =0A=
> > > =0A=
> > > The dwc3 driver would only give back the requests if the TRBs of the=
=0A=
> > > associated requests are completed or when the device is disconnected.=
=0A=
> > > If the TRB indicated missed isoc, that means that the TRB is complete=
d=0A=
> > > and its status was updated.=0A=
> > =0A=
> > Interesting, the device is not disconnected as we don't get the=0A=
> > -ESHUTDOWN status back and with this patch in place things continue=0A=
> > after a -EXDEV status is received.=0A=
> > =0A=
> =0A=
> Actually, minor correction here: a recent change=0A=
> b44c0e7fef51 ("usb: dwc3: gadget: conditionally remove requests")=0A=
> changed -ESHUTDOWN request status to -ECONNRESET when disable endpoint.=
=0A=
> This doesn't look right.=0A=
> =0A=
> While disabling endpoint may also apply for other cases such as=0A=
> switching alternate interface in addition to disconnect, -ESHUTDOWN=0A=
> seems more fitting there.=0A=
> =0A=
btw, we don't have "usb: dwc3: gadget: conditionally remove requests" in ou=
r baseline=0A=
=0A=
> Hi Michael,=0A=
> =0A=
> Can you help clarify for the change above? This changed the usage of=0A=
> requests. Now requests returned by disconnection won't be returned as=0A=
> -ESHUTDOWN.=0A=
> =0A=
> > > =0A=
> > > There's a special case which dwc3 may give back requests early is the=
=0A=
> > > case of the device disconnecting. The requests should be returned wit=
h=0A=
> > > -ESHUTDOWN, and the gadget driver shouldn't be re-using the requests =
on=0A=
> > > de-initialization anyway.=0A=
> > > =0A=
> > > We should not issue End Transfer command just because of missed isoc.=
 We=0A=
> > > may want issue End Transfer if the gadget driver is too slow and unab=
le=0A=
> > > to feed requests in time (causing underrun and missed isoc) to resync=
=0A=
> > > with the host, but we already handle that.=0A=
> > =0A=
> > Hmm, isn't that what happens when we get into this=0A=
> > condition in dwc3_gadget_endpoint_trbs_complete():=0A=
> > =0A=
> > 	if (usb_endpoint_xfer_isoc(dep->endpoint.desc) &&=0A=
> > 		list_empty(&dep->started_list) &&=0A=
> > 		(list_empty(&dep->pending_list) || status =3D=3D -EXDEV))=0A=
> > 		dwc3_stop_active_transfer(dep, true, true);=0A=
> > =0A=
> =0A=
> Yes, it's being handled there.=0A=
> =0A=
> > > =0A=
> > > I'm still not clear what's the problem you're seeing. Do you have the=
=0A=
> > > crash log? Tracepoints?=0A=
> > > =0A=
> > =0A=
> > Appreciate the support!=0A=
> > =0A=
> =0A=
> Thanks,=0A=
> Thinh=0A=
=0A=
Thanks,=0A=
Jeff=0A=
