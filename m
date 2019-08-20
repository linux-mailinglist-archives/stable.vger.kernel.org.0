Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EAB1496154
	for <lists+stable@lfdr.de>; Tue, 20 Aug 2019 15:47:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729838AbfHTNq3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Aug 2019 09:46:29 -0400
Received: from mail-eopbgr700062.outbound.protection.outlook.com ([40.107.70.62]:3260
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729827AbfHTNq3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 20 Aug 2019 09:46:29 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jQcxEXfL4bcGmFYaIwiU0WKmeii1Q8j67azq9tAj66eQFSCdM45bozd2/81qacVYDo7Fqg6iZuJO2hwhf0w6tPTRXNXbOGFqu8WVzYT/ZCDrAYoBhCFkCn7ptLh9isFQxmSmvKQhRDCf0ZS9BfZqmaHcx194WzMjKVcAgUVMXcpWT6xRnXj7hdsF+EU3IZu4QD61hA+A+jMbhK3fR0UcjyNG4lTDtEmKd38joRi9csbjNxM5uczKWdrA34sPhFDJV0D+as78ynbI3JLtEXcuXipRQTEU4oDXnOASVfWyWXfnGUF+KkhoNV3FA0CYa1h5CQjpOZtuvtt1WQLuQ11qdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gY1AYVEM+xrLRC9toEfDqk0xZzK7OohpFmUjDFKU9mc=;
 b=JVsLW9+7wzIfDjn8s+/bULISf4z1dodlQJBaN9DpCFmV87UdJTczTMrsanMEBYXVl1b2ZSKNtvobAHoMbj6J2KKnAPBTr/oLH9zKqnZDRrufzskLjyFfUksytSS3QBQhkfPTGSyeetSEjZUUmwjJux6YINddB326SpHdmAr1GOyARt1SP3BbWdSgaOF0VbsidIWZG4gvRmcGjLjWr30jLH1IYkYW25J3XhU3UP9NRjhX08w5lccAPOM4r3UlskU5/U+9YrVhFR7XWJ5r2FUPKvyfTltVOJ9cLXVfoIiD1X4EW4vXmYva1CBCebFmft4rCTQ++kGWVMh9TutW2HQM5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.60.100) smtp.rcpttodomain=linaro.org smtp.mailfrom=xilinx.com;
 dmarc=bestguesspass action=none header.from=xilinx.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gY1AYVEM+xrLRC9toEfDqk0xZzK7OohpFmUjDFKU9mc=;
 b=Dl3al2yUUlFNkSsyG+R+B7yk8S2xslEFmZN5m85IbkGFw83jwOD6U+bVdrCJBwuOXf9Z+jpla6krawHUAKLP/OrmDTKQ3f3lJIHC+Y5LaS75mJAJUWg39vLderpK677lJlmzFhrJFrotCN4VvYCt1h1KsjYVd9tLVVGxY8ZWPhc=
Received: from SN4PR0201CA0061.namprd02.prod.outlook.com
 (2603:10b6:803:20::23) by SN6PR02MB5310.namprd02.prod.outlook.com
 (2603:10b6:805:71::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2178.18; Tue, 20 Aug
 2019 13:46:26 +0000
Received: from CY1NAM02FT032.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e45::203) by SN4PR0201CA0061.outlook.office365.com
 (2603:10b6:803:20::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2178.16 via Frontend
 Transport; Tue, 20 Aug 2019 13:46:26 +0000
Authentication-Results: spf=pass (sender IP is 149.199.60.100)
 smtp.mailfrom=xilinx.com; linaro.org; dkim=none (message not signed)
 header.d=none;linaro.org; dmarc=bestguesspass action=none
 header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.60.100 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.60.100; helo=xsj-pvapsmtpgw02;
Received: from xsj-pvapsmtpgw02 (149.199.60.100) by
 CY1NAM02FT032.mail.protection.outlook.com (10.152.75.184) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2178.16
 via Frontend Transport; Tue, 20 Aug 2019 13:46:25 +0000
Received: from unknown-38-66.xilinx.com ([149.199.38.66]:33628 helo=xsj-pvapsmtp01)
        by xsj-pvapsmtpgw02 with esmtp (Exim 4.63)
        (envelope-from <michal.simek@xilinx.com>)
        id 1i04Sv-0006Td-5U; Tue, 20 Aug 2019 06:46:25 -0700
Received: from [127.0.0.1] (helo=localhost)
        by xsj-pvapsmtp01 with smtp (Exim 4.63)
        (envelope-from <michal.simek@xilinx.com>)
        id 1i04Sq-0007ut-1U; Tue, 20 Aug 2019 06:46:20 -0700
Received: from xsj-pvapsmtp01 (mail.xilinx.com [149.199.38.66] (may be forged))
        by xsj-smtp-dlp1.xlnx.xilinx.com (8.13.8/8.13.1) with ESMTP id x7KDkGHX015005;
        Tue, 20 Aug 2019 06:46:16 -0700
Received: from [172.30.17.116]
        by xsj-pvapsmtp01 with esmtp (Exim 4.63)
        (envelope-from <michals@xilinx.com>)
        id 1i04Sm-0007tl-Fz; Tue, 20 Aug 2019 06:46:16 -0700
Subject: Re: stable backports, from contents found in xilinx-4.9
To:     Linus Walleij <linus.walleij@linaro.org>,
        Michal Simek <michal.simek@xilinx.com>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        "stable-4.9" <stable@vger.kernel.org>,
        gregkh <gregkh@linuxfoundation.org>,
        Stefano Stabellini <sstabellini@kernel.org>,
        =?UTF-8?Q?S=c3=b6ren_Brinkmann?= <soren.brinkmann@xilinx.com>,
        Vinod Koul <vinod.koul@intel.com>,
        Felipe Balbi <balbi@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Wolfram Sang <wsa@the-dreams.de>,
        Viresh Kumar <viresh.kumar@linaro.org>
References: <CAK8P3a0gX2dM=VDjs2Ezh1EYM-buXCZ+79bdG2E+HCjO21StcA@mail.gmail.com>
 <a1f81a90-26e5-364b-743a-25a3525a9e99@xilinx.com>
 <CACRpkdY2zJNGMkf5+F1Zu2CrtG3-059uwsQopm0rS=aZUxjJzw@mail.gmail.com>
From:   Michal Simek <michal.simek@xilinx.com>
Message-ID: <d7a685c3-bc28-2135-f48c-5eded7dfa03d@xilinx.com>
Date:   Tue, 20 Aug 2019 15:46:13 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CACRpkdY2zJNGMkf5+F1Zu2CrtG3-059uwsQopm0rS=aZUxjJzw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-8.2.0.1013-23620.005
X-TM-AS-User-Approved-Sender: Yes;Yes
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:149.199.60.100;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(4636009)(346002)(376002)(136003)(396003)(39860400002)(2980300002)(199004)(189003)(52146003)(23676004)(58126008)(2486003)(2906002)(6666004)(64126003)(81156014)(81166006)(26005)(9786002)(110136005)(476003)(186003)(7416002)(8676002)(446003)(36756003)(8936002)(70586007)(70206006)(65806001)(36386004)(47776003)(76176011)(65956001)(106002)(31686004)(230700001)(478600001)(5660300002)(4744005)(6246003)(229853002)(126002)(305945005)(486006)(316002)(53546011)(44832011)(31696002)(356004)(63266004)(336012)(426003)(2616005)(4326008)(65826007)(11346002)(50466002)(54906003)(42866002)(5001870100001);DIR:OUT;SFP:1101;SCL:1;SRVR:SN6PR02MB5310;H:xsj-pvapsmtpgw02;FPR:;SPF:Pass;LANG:en;PTR:xapps1.xilinx.com,unknown-60-100.xilinx.com;A:1;MX:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1220a250-679e-4072-77d2-08d72574cbe8
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(4709080)(1401327)(2017052603328);SRVR:SN6PR02MB5310;
X-MS-TrafficTypeDiagnostic: SN6PR02MB5310:
X-Microsoft-Antispam-PRVS: <SN6PR02MB5310D00D4FD41ABE14A19EDAC6AB0@SN6PR02MB5310.namprd02.prod.outlook.com>
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-Forefront-PRVS: 013568035E
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: Mt4dmewF8dPn+g3ji9nYe/7Wu+deZ4WC8YyZ0exuLVnrfXeM3pP7PwkcWD20gvI91tVfwD9MLI4CXRzWdhQP8EQNPrc1LvypMolOpQpYfP+v2vajVeEgLTLbCZO/CWOvB1hxT4u3DhsO0ZNQbA/0sEsTTGZjGGxiqbAe97KeNdIMfVjf9gT39adlERf2KhYiYarhVPDxzWdEPxZi8vJJ0ktFTCtI7HQp7tFCg4GFAL9uTm/rhUpr5ySU+uwtPS4YYOAhKNJVaNmLKoLU/NByvt48lRuNBUGpUG1SzG6CbTW/7X2yUquUPSgRaeM4pcHt10aWGzjtbLPvk0Kl1YEtfVI19QLMaLXkQ/L3lCOl2Jed4lGQ3sVYhWk4Saz+X8+1L42JghvlJ+pXKoBegXWzq9iF1j5k59gqmeQhG8bCpNw=
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2019 13:46:25.7823
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1220a250-679e-4072-77d2-08d72574cbe8
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.60.100];Helo=[xsj-pvapsmtpgw02]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR02MB5310
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 20. 08. 19 15:29, Linus Walleij wrote:
> On Fri, Aug 16, 2019 at 8:54 AM Michal Simek <michal.simek@xilinx.com> wrote:
> 
>> What's the purpose of this work? Make v4.9 better?
> 
> Yes. The purpose is to pick all stuff you have backported and see if it should
> actually be in -stable so that stable is stable for everyone. It's kind of
> crowdfunding stable development.

Ok. I wasn't aware about it. What's the expectation from us in this?
Comment that list or it is just for information that this is happening
and stable maintainers should pick it up?

Thanks,
Michal

